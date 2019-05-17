 
// ��ȡidx/grp����ͼ�ļ���
// Ϊ����ٶȣ����û��淽ʽ��ȡ����idx/grp�����ڴ棬Ȼ�������ɸ��������
// �������ʵ�pic���ڻ��������


#include "jymain.h"

static struct PicFileCache pic_file[PIC_FILE_NUM];     

LIST_HEAD(cache_head);             //����cache����ͷ

static int currentCacheNum=0;             // ��ǰʹ�õ�cache��

static Uint32 m_color32[256];    // 256��ɫ��

extern int g_MAXCacheNum;                   // ���Cache����
extern Uint32 g_MaskColor32;      // ͸��ɫ
extern int g_ScreenW ;
extern int g_ScreenH ;

int CacheFailNum=0;

// ��ʼ��Cache���ݡ���Ϸ��ʼʱ����
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

// ��ʼ����ͼcache��Ϣ
// PalletteFilename Ϊ256��ɫ���ļ�����һ�ε���ʱ����
//                  Ϊ���ַ������ʾ���������ͼcache��Ϣ��������ͼ/����/ս���л�ʱ����
int JY_PicInit(char *PalletteFilename)
{

    struct list_head *pos,*p;
    int i;
 
	LoadPallette(PalletteFilename);   //�����ɫ��

    //�������Ϊ�գ�ɾ��ȫ������
    list_for_each_safe(pos,p,&cache_head){
        struct CacheNode *tmp= list_entry(pos, struct CacheNode , list);
        if(tmp->s!=NULL) 
			SDL_FreeSurface(tmp->s);       //ɾ������
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

// �����ļ���Ϣ
// filename �ļ���  ����Ҫ��׺��idx/grp
// id  0-9
int JY_PicLoadFile(const char*filename, int id)
{
    int i;
    struct CacheNode *tmpcache;
    char str[255];
    FILE *fp;
    int count;

    if(id<0 || id>=PIC_FILE_NUM){  // id������Χ
        return 1;
	}

	if(pic_file[id].pcache){        //�ͷŵ�ǰ�ļ�ռ�õĿռ䣬������cache
		int i;
		for(i=0;i<pic_file[id].num;i++){   //ѭ��ȫ����ͼ��
            tmpcache=pic_file[id].pcache[i];
            if(tmpcache){       // ����ͼ�л�����ɾ��
			    if(tmpcache->s!=NULL) 
				    SDL_FreeSurface(tmpcache->s);       //ɾ������
			    list_del(&tmpcache->list);              //ɾ������
			    SafeFree(tmpcache);                  //�ͷ�cache�ڴ�
                currentCacheNum--;
            }
		}
        SafeFree(pic_file[id].pcache);
    }
    SafeFree(pic_file[id].idx);
    SafeFree(pic_file[id].grp);

    // ��ȡidx�ļ�
    sprintf(str,"%s.idx",filename);
	
	pic_file[id].num =FileLength(str)/4;    //idx ��ͼ����
    pic_file[id].idx =(int *)malloc((pic_file[id].num+1)*4);
    if(pic_file[id].idx ==NULL){
		fprintf(stderr,"JY_PicLoadFile: cannot malloc idx memory!\n");
		return 1;
    }
		//��ȡ��ͼidx�ļ�
	if((fp=fopen(str,"rb"))==NULL){
        fprintf(stderr,"JY_PicLoadFile: idx file not open ---%s",str);
		return 1;
	}

    count=fread(&pic_file[id].idx[1],4,pic_file[id].num,fp);
    fclose(fp);
 
    pic_file[id].idx[0]=0;

    //��ȡgrp�ļ�
    sprintf(str,"%s.grp",filename);

    pic_file[id].filelength=FileLength(str);

    pic_file[id].grp =(unsigned char*)malloc(pic_file[id].filelength);
    if(pic_file[id].grp ==NULL){
		fprintf(stderr,"JY_PicLoadFile: cannot malloc grp memory!\n");
		return 1;
    }
		//��ȡ��ͼgrp�ļ�
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

// ���ز���ʾ��ͼ
// fileid        ��ͼ�ļ�id 
// picid     ��ͼ���
// x,y       ��ʾλ��
//  flag ��ͬbit����ͬ���壬ȱʡ��Ϊ0
//  B0    0 ����ƫ��xoff��yoff��=1 ������ƫ����
//  B1    0     , 1 �뱳��alpla �����ʾ, value Ϊalphaֵ(0-256), 0��ʾ͸��
//  B2            1 ȫ��
//  B3            1 ȫ��
//  value ����flag���壬Ϊalphaֵ�� 

int JY_LoadPic(int fileid, int picid, int x,int y,int flag,int value)
{
 
    struct CacheNode *newcache,*tmpcache;
	int find=0;
 
 	picid=picid/2;

	if(fileid<0 || fileid >=PIC_FILE_NUM || picid<0 || picid>=pic_file[fileid].num )    // ��������
		return 1;

	if(pic_file[fileid].pcache[picid]==NULL){   //��ǰ��ͼû�м���
		//����cache����
		newcache=(struct CacheNode *)malloc(sizeof(struct CacheNode));
		if(newcache==NULL){
			fprintf(stderr,"JY_LoadPic: cannot malloc newcache memory!\n");
			return 1;
		}

		newcache->s=LoadPic(fileid,picid,&newcache->xoff,&newcache->yoff);
        newcache->id =picid;
		newcache->fileid =fileid;
        pic_file[fileid].pcache[picid]=newcache;

        if(currentCacheNum<g_MAXCacheNum){  //cacheû��
            list_add(&newcache->list ,&cache_head);    //���ص���ͷ
            currentCacheNum=currentCacheNum+1;
 		}
		else{   //cache ����
            tmpcache=list_entry(cache_head.prev, struct CacheNode , list);  //���һ��cache
            pic_file[tmpcache->fileid].pcache[tmpcache->id]=NULL;
			if(tmpcache->s!=NULL) 
				SDL_FreeSurface(tmpcache->s);       //ɾ������
			list_del(&tmpcache->list);
			SafeFree(tmpcache);
			
			list_add(&newcache->list ,&cache_head);    //���ص���ͷ
            CacheFailNum++;
            if(CacheFailNum % 100 ==1)
                JY_Debug("Pic Cache is full!");
        }
    }
	else{   //�Ѽ�����ͼ
 		newcache=pic_file[fileid].pcache[picid];
		list_del(&newcache->list);    //�����cache������ժ��
		list_add(&newcache->list ,&cache_head);    //�ٲ��뵽��ͷ
	}

	if(flag & 0x00000001)
        BlitSurface(newcache->s , x,y,flag,value);
	else
        BlitSurface(newcache->s , x - newcache->xoff,y - newcache->yoff,flag,value);
 
 
    return 0;
}

// ������ͼ������
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


	// ����һЩ��������������޸����еĴ���
	if(id1<0)
		datalong=0;
 
	if(id2>pic_file[fileid].filelength)
		id2=pic_file[fileid].filelength;

	datalong=id2-id1;

 
	if(datalong>0){
		//��ȡ��ͼgrp�ļ����õ�ԭʼ����        
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
        else{      //��ȡpng��ʽ
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


//�õ���ͼ��С
int JY_GetPicXY(int fileid, int picid, int *w,int *h)
{
    struct CacheNode *newcache;
	int r=JY_LoadPic(fileid, picid, g_ScreenW+1,g_ScreenH+1,1,0);   //������ͼ����������λ��

    *w=0;
	*h=0;

	if(r!=0)
		return 1;

    newcache=pic_file[fileid].pcache[picid/2];

    if(newcache->s){      // ���У���ֱ����ʾ
        *w= newcache->s->w;
        *h= newcache->s->h;
	}

	return 0;
}




//����ԭ����Ϸ��RLE��ʽ��������
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
        row=data[p];            // i�����ݸ���
		start=p;
		p++;
		if(row>0){
			x=0;                // i��Ŀǰ��
            while(1){
                x=x+data[p];    // i�пհ׵����������͸����
				if(x>=w)        // i�п�ȵ�ͷ������
					break;

				p++;
                solidnum=data[p];  // ��͸�������
                p++;
				for(j=0;j<solidnum;j++){
                    data32[yoffset+x]=m_color32[data[p]];
					p++;
					x++;
				}
                if(x>=w)
					break;     // i�п�ȵ�ͷ������
				if(p-start>=row) 
					break;    // i��û�����ݣ�����
			}
            if(p+1>=datalong) 
				break;
		}
	}
    
 
    ps1=SDL_CreateRGBSurfaceFrom(data32,w,h,32,w*4,0xff0000,0xff00,0xff,0);  //����32λ����
	if(ps1==NULL){
		fprintf(stderr,"CreatePicSurface32: cannot create SDL_Surface ps1!\n");
	}
	ps2=SDL_DisplayFormat(ps1);   // ��32λ�����Ϊ��ǰ����
	if(ps2==NULL){
		fprintf(stderr,"CreatePicSurface32: cannot create SDL_Surface ps2!\n");
	}

	SDL_FreeSurface(ps1);      
	SafeFree(data32);
   	
    SDL_SetColorKey(ps2,SDL_SRCCOLORKEY|SDL_RLEACCEL ,ConvertColor(g_MaskColor32));  //ʹ��RLE����

    return ps2;
   	
}


// ��ȡ��ɫ��
// �ļ���Ϊ����ֱ�ӷ���
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