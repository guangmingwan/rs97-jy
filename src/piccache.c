 
// 读取idx/grp的贴图文件。
// 为提高速度，采用缓存方式读取。把idx/grp读入内存，然后定义若干个缓存表面
// 经常访问的pic放在缓存表面中


#include "jymain.h"

static struct PicFileCache pic_file[PIC_FILE_NUM];     

LIST_HEAD(cache_head);             //定义cache链表头

static int currentCacheNum=0;             // 当前使用的cache数

static Uint32 m_color32[256];    // 256调色板

extern int g_MAXCacheNum;                   // 最大Cache个数
extern Uint32 g_MaskColor32;      // 透明色
extern int g_ScreenW ;
extern int g_ScreenH ;

int CacheFailNum=0;

// 初始化Cache数据。游戏开始时调用
int Init_Cache()
{
    int i;
    for(i=0;i<PIC_FILE_NUM;i++){
        pic_file[i].num =0;
        pic_file[i].idx =NULL;
        pic_file[i].grp=NULL;
        pic_file[i].pcache=NULL;
    }
    return 0;
}

// 初始化贴图cache信息
// PalletteFilename 为256调色板文件。第一次调用时载入
//                  为空字符串则表示重新清空贴图cache信息。在主地图/场景/战斗切换时调用
int JY_PicInit(char *PalletteFilename)
{

    struct list_head *pos,*p;
    int i;
 
	LoadPallette(PalletteFilename);   //载入调色板

    //如果链表不为空，删除全部链表
    list_for_each_safe(pos,p,&cache_head){
        struct CacheNode *tmp= list_entry(pos, struct CacheNode , list);
        if(tmp->s!=NULL) 
			SDL_FreeSurface(tmp->s);       //删除表面
		list_del(pos);		 
		SafeFree(tmp);
	}

    for(i=0;i<PIC_FILE_NUM;i++){
        pic_file[i].num =0;
        SafeFree(pic_file[i].idx);
        SafeFree(pic_file[i].grp);
        SafeFree(pic_file[i].pcache);
    }

    currentCacheNum=0; 
    CacheFailNum=0;
    return 0;

}

// 加载文件信息
// filename 文件名  不需要后缀，idx/grp
// id  0-9
int JY_PicLoadFile(const char*filename, int id)
{
    int i;
    struct CacheNode *tmpcache;
    char str[255];
    FILE *fp;
    int count;

    if(id<0 || id>=PIC_FILE_NUM){  // id超出范围
        return 1;
	}

	if(pic_file[id].pcache){        //释放当前文件占用的空间，并清理cache
		int i;
		for(i=0;i<pic_file[id].num;i++){   //循环全部贴图，
            tmpcache=pic_file[id].pcache[i];
            if(tmpcache){       // 该贴图有缓存则删除
			    if(tmpcache->s!=NULL) 
				    SDL_FreeSurface(tmpcache->s);       //删除表面
			    list_del(&tmpcache->list);              //删除链表
			    SafeFree(tmpcache);                  //释放cache内存
                currentCacheNum--;
            }
		}
        SafeFree(pic_file[id].pcache);
    }
    SafeFree(pic_file[id].idx);
    SafeFree(pic_file[id].grp);

    // 读取idx文件
    sprintf(str,"%s.idx",filename);
	
	pic_file[id].num =FileLength(str)/4;    //idx 贴图个数
    pic_file[id].idx =(int *)malloc((pic_file[id].num+1)*4);
    if(pic_file[id].idx ==NULL){
		fprintf(stderr,"JY_PicLoadFile: cannot malloc idx memory!\n");
		return 1;
    }
		//读取贴图idx文件
	if((fp=fopen(str,"rb"))==NULL){
        fprintf(stderr,"JY_PicLoadFile: idx file not open ---%s",str);
		return 1;
	}

    count=fread(&pic_file[id].idx[1],4,pic_file[id].num,fp);
    fclose(fp);
 
    pic_file[id].idx[0]=0;

    //读取grp文件
    sprintf(str,"%s.grp",filename);

    pic_file[id].filelength=FileLength(str);

    pic_file[id].grp =(unsigned char*)malloc(pic_file[id].filelength);
    if(pic_file[id].grp ==NULL){
		fprintf(stderr,"JY_PicLoadFile: cannot malloc grp memory!\n");
		return 1;
    }
		//读取贴图grp文件
	if((fp=fopen(str,"rb"))==NULL){
        fprintf(stderr,"JY_PicLoadFile: grp file not open ---%s",str);
		return 1;
	}
    count=fread(pic_file[id].grp,1,pic_file[id].filelength,fp);
    fclose(fp);


    pic_file[id].pcache =(struct CacheNode **)malloc(pic_file[id].num*sizeof(struct CacheNode *));
    if(pic_file[id].pcache ==NULL){
		fprintf(stderr,"JY_PicLoadFile: cannot malloc pcache memory!\n");
		return 1;
    }
  	
	for(i=0;i<pic_file[id].num;i++)
		pic_file[id].pcache[i]=NULL;

    return 0;
} 

// 加载并显示贴图
// fileid        贴图文件id 
// picid     贴图编号
// x,y       显示位置
//  flag 不同bit代表不同含义，缺省均为0
//  B0    0 考虑偏移xoff，yoff。=1 不考虑偏移量
//  B1    0     , 1 与背景alpla 混合显示, value 为alpha值(0-256), 0表示透明
//  B2            1 全黑
//  B3            1 全白
//  value 按照flag定义，为alpha值， 

int JY_LoadPic(int fileid, int picid, int x,int y,int flag,int value)
{
 
    struct CacheNode *newcache,*tmpcache;
	int find=0;
 
 	picid=picid/2;

	if(fileid<0 || fileid >=PIC_FILE_NUM || picid<0 || picid>=pic_file[fileid].num )    // 参数错误
		return 1;

	if(pic_file[fileid].pcache[picid]==NULL){   //当前贴图没有加载
		//生成cache数据
		newcache=(struct CacheNode *)malloc(sizeof(struct CacheNode));
		if(newcache==NULL){
			fprintf(stderr,"JY_LoadPic: cannot malloc newcache memory!\n");
			return 1;
		}

		newcache->s=LoadPic(fileid,picid,&newcache->xoff,&newcache->yoff);
        newcache->id =picid;
		newcache->fileid =fileid;
        pic_file[fileid].pcache[picid]=newcache;

        if(currentCacheNum<g_MAXCacheNum){  //cache没满
            list_add(&newcache->list ,&cache_head);    //加载到表头
            currentCacheNum=currentCacheNum+1;
 		}
		else{   //cache 已满
            tmpcache=list_entry(cache_head.prev, struct CacheNode , list);  //最后一个cache
            pic_file[tmpcache->fileid].pcache[tmpcache->id]=NULL;
			if(tmpcache->s!=NULL) 
				SDL_FreeSurface(tmpcache->s);       //删除表面
			list_del(&tmpcache->list);
			SafeFree(tmpcache);
			
			list_add(&newcache->list ,&cache_head);    //加载到表头
            CacheFailNum++;
            if(CacheFailNum % 100 ==1)
                JY_Debug("Pic Cache is full!");
        }
    }
	else{   //已加载贴图
 		newcache=pic_file[fileid].pcache[picid];
		list_del(&newcache->list);    //把这个cache从链表摘出
		list_add(&newcache->list ,&cache_head);    //再插入到表头
	}

	if(flag & 0x00000001)
        BlitSurface(newcache->s , x,y,flag,value);
	else
        BlitSurface(newcache->s , x - newcache->xoff,y - newcache->yoff,flag,value);
 
 
    return 0;
}

// 加载贴图到表面
static SDL_Surface *LoadPic(int fileid,int picid, int *xoffset,int *yoffset)
{

 
	SDL_RWops *fp_SDL;
	int id1,id2;
	int datalong;
    unsigned char *p,*data;

    SDL_Surface *tmpsurf=NULL;

    SDL_Surface *surf=NULL;

    if(pic_file[fileid].idx ==NULL){
        fprintf(stderr,"LoadPic: fileid %d can not load?\n",fileid);
        return NULL;
    }
    id1=pic_file[fileid].idx[picid];
    id2=pic_file[fileid].idx[picid+1];


	// 处理一些特殊情况，按照修改器中的代码
	if(id1<0)
		datalong=0;
 
	if(id2>pic_file[fileid].filelength)
		id2=pic_file[fileid].filelength;

	datalong=id2-id1;

 
	if(datalong>0){
		//读取贴图grp文件，得到原始数据        
        p=pic_file[fileid].grp+id1;
        fp_SDL=SDL_RWFromMem(p,datalong);
		if(IMG_isPNG(fp_SDL)==0){
	        short width,height,xoff,yoff;
            width =*(short*)p;
            height=*(short*)(p+2);
            xoff=*(short*)(p+4);
            yoff=*(short*)(p+6);
			data=p+8;

			surf=CreatePicSurface32(data,width,height,datalong-8);

			*xoffset =xoff;
			*yoffset =yoff;
		}
        else{      //读取png格式
            tmpsurf=IMG_LoadPNG_RW(fp_SDL);
	        if(tmpsurf==NULL){
		        fprintf(stderr,"LoadPic: cannot create SDL_Surface tmpsurf!\n");
	        }
            *xoffset=tmpsurf->w/2;
            *yoffset=tmpsurf->h/2;
            surf=tmpsurf;
 		}
        SDL_FreeRW(fp_SDL);
    }
    else{

	}

  

    return surf;
}


//得到贴图大小
int JY_GetPicXY(int fileid, int picid, int *w,int *h)
{
    struct CacheNode *newcache;
	int r=JY_LoadPic(fileid, picid, g_ScreenW+1,g_ScreenH+1,1,0);   //加载贴图到看不见的位置

    *w=0;
	*h=0;

	if(r!=0)
		return 1;

    newcache=pic_file[fileid].pcache[picid/2];

    if(newcache->s){      // 已有，则直接显示
        *w= newcache->s->w;
        *h= newcache->s->h;
	}

	return 0;
}




//按照原来游戏的RLE格式创建表面
static SDL_Surface* CreatePicSurface32(unsigned char *data, int w,int h,int datalong)
{    
	int x1=0,y1=0,p=0;    
	int i,j;
	int yoffset;
	int row;
	int start;
    int x;
    int solidnum;
	SDL_Surface *ps1,*ps2 ;
    Uint32 *data32=NULL;

    data32=(Uint32 *)malloc(w*h*4);
	if(data32==NULL){
		fprintf(stderr,"CreatePicSurface32: cannot malloc data32 memory!\n");
		return NULL;
	}

	for(i=0;i<w*h;i++)
		data32[i]=g_MaskColor32;

	for(i=0;i<h;i++){
        yoffset=i*w;       
        row=data[p];            // i行数据个数
		start=p;
		p++;
		if(row>0){
			x=0;                // i行目前列
            while(1){
                x=x+data[p];    // i行空白点个数，跳个透明点
				if(x>=w)        // i行宽度到头，结束
					break;

				p++;
                solidnum=data[p];  // 不透明点个数
                p++;
				for(j=0;j<solidnum;j++){
                    data32[yoffset+x]=m_color32[data[p]];
					p++;
					x++;
				}
                if(x>=w)
					break;     // i行宽度到头，结束
				if(p-start>=row) 
					break;    // i行没有数据，结束
			}
            if(p+1>=datalong) 
				break;
		}
	}
    
 
    ps1=SDL_CreateRGBSurfaceFrom(data32,w,h,32,w*4,0xff0000,0xff00,0xff,0);  //创建32位表面
	if(ps1==NULL){
		fprintf(stderr,"CreatePicSurface32: cannot create SDL_Surface ps1!\n");
	}
	ps2=SDL_DisplayFormat(ps1);   // 把32位表面改为当前表面
	if(ps2==NULL){
		fprintf(stderr,"CreatePicSurface32: cannot create SDL_Surface ps2!\n");
	}

	SDL_FreeSurface(ps1);      
	SafeFree(data32);
   	
    SDL_SetColorKey(ps2,SDL_SRCCOLORKEY|SDL_RLEACCEL ,ConvertColor(g_MaskColor32));  //使用RLE加速

    return ps2;
   	
}


// 读取调色板
// 文件名为空则直接返回
static int LoadPallette(char *filename)
{
    FILE *fp;
	char color[3];
	int i;
	if(strlen(filename)==0)    
		return 1;
	if((fp=fopen(filename,"rb"))==NULL){
        fprintf(stderr,"Pallette File not open ---%s",filename);
		return 1;
	}
	for(i=0;i<256;i++)
	{
         fread(color,1,3,fp);
         m_color32[i]=color[0]*4*65536l+color[1]*4*256+color[2]*4 ;
 
	}
	fclose(fp);

	return 0;
}