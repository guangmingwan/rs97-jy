
// 输出汉字和字符集转换 


//为保证平台兼容性，自己生成了一个gbk简体/繁体/big5/unicode的码表文件
//通过此文件，即可进行各种格式的转换 

#include <stdlib.h>
#include "jymain.h"


// 显示TTF 字符串
// 为快速显示，程序将保存已经打开的相应字号的字体结构。这样做可以加快程序速度
// 为简化代码，没有用链表，而是采用数组来保存打开的字体。
// 用先进先出的方法，循环关闭已经打开的字体。
// 考虑到一般打开的字体不多，比如640*480模式实际上只用了16*24*32三种字体。
// 设置数组为10已经足够。

static UseFont Font[FONTNUM];         //保存已打开的字体

static int currentFont=0;

//字符集转换数组
static Uint16 gbkj_f[128][256];        //GBK简体-->繁体
static Uint16 gbkf_j[128][256] ;
static Uint16 gbk_unicode[128][256] ;
static Uint16 gbk_big5[128][256] ;
static Uint16 big5_gbk[128][256] ;

extern  SDL_Surface* g_Surface;    //屏幕表面

//初始化
int InitFont()
{
    int i;

	TTF_Init();  // 初始化sdl_ttf

    for(i=0;i<FONTNUM;i++){   //字体数据初值
        Font[i].size =0;
	    Font[i].name=NULL;
		Font[i].font =NULL;
    }
 
	return 0;
}

//释放字体结构
int ExitFont()
{
    int i;

    for(i=0;i<FONTNUM;i++){  //释放字体数据
		if(Font[i].font){
			TTF_CloseFont(Font[i].font);
		}
        SafeFree(Font[i].name);
	}

    TTF_Quit();

	return 0;
}


// 根据字体文件名和字号打开字体
// size 为按像素大小的字号
static TTF_Font *GetFont(const char *filename,int size)
{
    int i;
	TTF_Font *myfont=NULL;
	
	for(i=0;i<FONTNUM;i++){   //  判断字体是否已打开
		if((Font[i].size ==size) && (Font[i].name) && (strcmp(filename,Font[i].name)==0) ){   
			myfont=Font[i].font ;
			break;
		}
    }

	if(myfont==NULL){    //没有打开
		myfont =TTF_OpenFont(filename,size);           //打开新字体
		if(myfont==NULL){
            fprintf(stderr,"GetFont error: can not open font file %s\n",filename);
			return NULL;
		}
		Font[currentFont].size =size;
		if(Font[currentFont].font)           //直接关闭当前字体。
            TTF_CloseFont(Font[currentFont].font);

        Font[currentFont].font=myfont; 

        SafeFree(Font[currentFont].name);
        Font[currentFont].name =(char*)malloc(strlen(filename)+1);
		strcpy(Font[currentFont].name,filename);
        
        currentFont++;           // 增加队列入口计数
		if(currentFont==FONTNUM)                  
			currentFont=0;
	}
	
	return myfont;

}

// 写字符串
// x,y 坐标
// str 字符串
// color 颜色
// size 字体大小，字形为宋体。 
// fontname 字体名
// charset 字符集 0 GBK 1 big5
// OScharset 无用
int JY_DrawStr(int x, int y, const char *str,int color,int size,const char *fontname, 
			   int charset, int OScharset)
{
    SDL_Color c;   
	SDL_Surface *fontSurface=NULL;
	SDL_Rect rect;
	Uint8 *tmp;
	int flag=0;

    TTF_Font *myfont=GetFont(fontname,size);
	if(myfont==NULL)
		return 1;

    c.r=(color & 0xff0000) >>16;
	c.g=(color & 0xff00)>>8;
	c.b=(color & 0xff);
 
    tmp=(char*)malloc(2*strlen(str)+1);  //分配两倍原字符串大小的内存，避免转换到unicode时溢出

    if(charset==0){     //GBK
        JY_CharSet(str,tmp,3);      
	}
	else if(charset==1){ //big5
        JY_CharSet(str,tmp,2);
	}
	else{
        strcpy(tmp,str);
	}

    fontSurface=TTF_RenderUNICODE_Solid(myfont, (Uint16*)tmp, c);  //生成表面

	SafeFree(tmp);

	if(fontSurface==NULL)
		return 1;

    rect.x=x;
	rect.y=y;

    SDL_BlitSurface(fontSurface, NULL, g_Surface, &rect);    //表面写道游戏表面 
    SDL_FreeSurface(fontSurface);   //释放表面
    return 0;
}

  

// 汉字字符集转换
// flag = 0   Big5 --> GBK     
//      = 1   GBK  --> Big5    
//      = 2   Big5 --> Unicode
//      = 3   GBK  --> Unicode
// 注意要保证dest有足够的空间，一般建议取src长度的两倍+1，保证全英文字符也能转化为unicode
int  JY_CharSet(const char *src, char *dest, int flag)
{
 
    char *psrc,*pdest;
    unsigned char b0,b1;
	int d0;
	Uint16 tmpchar;

	psrc=(char*)src;
	pdest=dest;

    while(1){
        b0=*psrc;
		if(b0==0){       //字符串结束
			if( (flag==0) || (flag==1) ){
				*pdest=0;
				break;
			}
			else{    //unicode结束标志 0x0000?
				*pdest=0;
				*(pdest+1)=0;
				break;                
			}
		}
		if(b0<128){      //英文字符
			if( (flag==0) || (flag==1) ){  //不转换
				*pdest=b0;
				pdest++;
				psrc++;
			}
			else{                //unicode 后面加个0
				*pdest=b0;
				pdest++;
				*pdest=0;
				pdest++;
				psrc++;                
			}
		}
		else{              //中文字符
			b1=*(psrc+1);
            if(b1==0){     // 非正常结束
                *pdest='?';
				*(pdest+1)=0;
				break;
			}
			else{
				d0=b0+b1*256;
				switch(flag){
				case 0:   //Big5 --> GBK    
					//tmpchar=big5_gbk[d0];
					tmpchar=big5_gbk[b0-128][b1];
					if(gbkf_j[(tmpchar & 0xff)-128][( tmpchar &0xff00)>>8]>0)
					    tmpchar=gbkf_j[(tmpchar & 0xff)-128][( tmpchar &0xff00)>>8];
					break;
				case 1:   //GBK  --> Big5  
					if(gbkj_f[b0-128][b1]>0)
					    tmpchar=gbkj_f[b0-128][b1];
					else
						tmpchar=d0;
											
					tmpchar=gbk_big5[(tmpchar & 0xff)-128][( tmpchar &0xff00)>>8];
					break;
				case 2:   //Big5 --> Unicode
					tmpchar=big5_gbk[b0][b1];
					tmpchar=gbk_unicode[(tmpchar & 0xff)-128][( tmpchar &0xff00)>>8];
					break;
				case 3:   //GBK  --> Unicode
					tmpchar=gbk_unicode[b0-128][b1];
					break;                
				}

                *(Uint16*)pdest=tmpchar;

				pdest=pdest+2;
				psrc=psrc+2;
			}
        }
	}

    return 0;
}


//加载码表文件
//码表文件按照GBK顺序排序，每个GBK字符对应三个字符：gbkf,big5,unicode
int LoadMB(const char* mbfile)
{
	FILE *fp;
	int i,j;

	Uint16 gbk,gbkf,big5,unicode;
 
	fp=fopen(mbfile,"rb");
    if(fp==NULL){
		fprintf(stderr,"cannot open mbfile");
		return 1;
	}


	for(i=0;i<128;i++){
		for(j=0;j<256;j++){
			gbkj_f[i][j]=0;
			gbkf_j[i][j]=0;
			gbk_unicode[i][j]=0;
 
			gbk_big5[i][j]=0;
			big5_gbk[i][j]=0;
		}
	}

    for(i=0x81;i<=0xfe;i++)
		for(j=0x40;j<=0xfe;j++){
			if( j != 0x7f){
				gbk=i+j*256;
				fread(&gbkf,2,1,fp);
				fread(&big5,2,1,fp);
				fread(&unicode,2,1,fp);
                
				if(gbk!=gbkf){
 				    gbkj_f[i-128][j]=gbkf;
				    gbkf_j[(gbkf&0xff)-128][(gbkf&0xff00)>>8]=gbk;
				}
				gbk_unicode[i-128][j]=unicode;

				if(gbkj_f[i-128][j]==0){   //没有简体
				    gbk_big5[i-128][j]=big5;
				    big5_gbk[(big5 & 0xff)-128][( big5 &0xff00)>>8]=gbk;
				}
            }
		}

	fclose(fp);
    
    return 0;
}


 