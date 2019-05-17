
// ������ֺ��ַ���ת�� 


//Ϊ��֤ƽ̨�����ԣ��Լ�������һ��gbk����/����/big5/unicode������ļ�
//ͨ�����ļ������ɽ��и��ָ�ʽ��ת�� 

#include <stdlib.h>
#include "jymain.h"


// ��ʾTTF �ַ���
// Ϊ������ʾ�����򽫱����Ѿ��򿪵���Ӧ�ֺŵ�����ṹ�����������Լӿ�����ٶ�
// Ϊ�򻯴��룬û�����������ǲ�������������򿪵����塣
// ���Ƚ��ȳ��ķ�����ѭ���ر��Ѿ��򿪵����塣
// ���ǵ�һ��򿪵����岻�࣬����640*480ģʽʵ����ֻ����16*24*32�������塣
// ��������Ϊ10�Ѿ��㹻��

static UseFont Font[FONTNUM];         //�����Ѵ򿪵�����

static int currentFont=0;

//�ַ���ת������
static Uint16 gbkj_f[128][256];        //GBK����-->����
static Uint16 gbkf_j[128][256] ;
static Uint16 gbk_unicode[128][256] ;
static Uint16 gbk_big5[128][256] ;
static Uint16 big5_gbk[128][256] ;

extern  SDL_Surface* g_Surface;    //��Ļ����

//��ʼ��
int InitFont()
{
    int i;

	TTF_Init();  // ��ʼ��sdl_ttf

    for(i=0;i<FONTNUM;i++){   //�������ݳ�ֵ
        Font[i].size =0;
	    Font[i].name=NULL;
		Font[i].font =NULL;
    }
 
	return 0;
}

//�ͷ�����ṹ
int ExitFont()
{
    int i;

    for(i=0;i<FONTNUM;i++){  //�ͷ���������
		if(Font[i].font){
			TTF_CloseFont(Font[i].font);
		}
        SafeFree(Font[i].name);
	}

    TTF_Quit();

	return 0;
}


// ���������ļ������ֺŴ�����
// size Ϊ�����ش�С���ֺ�
static TTF_Font *GetFont(const char *filename,int size)
{
    int i;
	TTF_Font *myfont=NULL;
	
	for(i=0;i<FONTNUM;i++){   //  �ж������Ƿ��Ѵ�
		if((Font[i].size ==size) && (Font[i].name) && (strcmp(filename,Font[i].name)==0) ){   
			myfont=Font[i].font ;
			break;
		}
    }

	if(myfont==NULL){    //û�д�
		myfont =TTF_OpenFont(filename,size);           //��������
		if(myfont==NULL){
            fprintf(stderr,"GetFont error: can not open font file %s\n",filename);
			return NULL;
		}
		Font[currentFont].size =size;
		if(Font[currentFont].font)           //ֱ�ӹرյ�ǰ���塣
            TTF_CloseFont(Font[currentFont].font);

        Font[currentFont].font=myfont; 

        SafeFree(Font[currentFont].name);
        Font[currentFont].name =(char*)malloc(strlen(filename)+1);
		strcpy(Font[currentFont].name,filename);
        
        currentFont++;           // ���Ӷ�����ڼ���
		if(currentFont==FONTNUM)                  
			currentFont=0;
	}
	
	return myfont;

}

// д�ַ���
// x,y ����
// str �ַ���
// color ��ɫ
// size �����С������Ϊ���塣 
// fontname ������
// charset �ַ��� 0 GBK 1 big5
// OScharset ����
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
 
    tmp=(char*)malloc(2*strlen(str)+1);  //��������ԭ�ַ�����С���ڴ棬����ת����unicodeʱ���

    if(charset==0){     //GBK
        JY_CharSet(str,tmp,3);      
	}
	else if(charset==1){ //big5
        JY_CharSet(str,tmp,2);
	}
	else{
        strcpy(tmp,str);
	}

    fontSurface=TTF_RenderUNICODE_Solid(myfont, (Uint16*)tmp, c);  //���ɱ���

	SafeFree(tmp);

	if(fontSurface==NULL)
		return 1;

    rect.x=x;
	rect.y=y;

    SDL_BlitSurface(fontSurface, NULL, g_Surface, &rect);    //����д����Ϸ���� 
    SDL_FreeSurface(fontSurface);   //�ͷű���
    return 0;
}

  

// �����ַ���ת��
// flag = 0   Big5 --> GBK     
//      = 1   GBK  --> Big5    
//      = 2   Big5 --> Unicode
//      = 3   GBK  --> Unicode
// ע��Ҫ��֤dest���㹻�Ŀռ䣬һ�㽨��ȡsrc���ȵ�����+1����֤ȫӢ���ַ�Ҳ��ת��Ϊunicode
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
		if(b0==0){       //�ַ�������
			if( (flag==0) || (flag==1) ){
				*pdest=0;
				break;
			}
			else{    //unicode������־ 0x0000?
				*pdest=0;
				*(pdest+1)=0;
				break;                
			}
		}
		if(b0<128){      //Ӣ���ַ�
			if( (flag==0) || (flag==1) ){  //��ת��
				*pdest=b0;
				pdest++;
				psrc++;
			}
			else{                //unicode ����Ӹ�0
				*pdest=b0;
				pdest++;
				*pdest=0;
				pdest++;
				psrc++;                
			}
		}
		else{              //�����ַ�
			b1=*(psrc+1);
            if(b1==0){     // ����������
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


//��������ļ�
//����ļ�����GBK˳������ÿ��GBK�ַ���Ӧ�����ַ���gbkf,big5,unicode
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

				if(gbkj_f[i-128][j]==0){   //û�м���
				    gbk_big5[i-128][j]=big5;
				    big5_gbk[(big5 & 0xff)-128][( big5 &0xff00)>>8]=gbk;
				}
            }
		}

	fclose(fp);
    
    return 0;
}


 