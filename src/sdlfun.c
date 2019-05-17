 

// SDL ��غ���

#include "jymain.h"
 
static Mix_Music *currentMusic=NULL;         //�����������ݣ�����ͬʱֻ����һ������һ������

#define WAVNUM 5

static Mix_Chunk *WavChunk[WAVNUM];        //������Ч���ݣ�����ͬʱ���ż��������������

static int currentWav=0;                  //��ǰ���ŵ���Ч

extern SDL_Surface* g_Surface;        // ��Ϸʹ�õ���Ƶ����
extern Uint32 g_MaskColor32;      // ͸��ɫ

extern int g_ScreenW ;
extern int g_ScreenH ;
extern int g_ScreenBpp ;

extern int g_FullScreen;
extern int g_EnableSound;
extern int g_MusicVolume;
extern int g_SoundVolume;



// ��ʼ��SDL
int InitSDL(void)
{
	int r;
	int i;
	char tmpstr[255];
   
	r=SDL_Init(SDL_INIT_VIDEO);
    if( r < 0 ) {
        fprintf(stderr,
                "Couldn't initialize SDL: %s\n", SDL_GetError());
        exit(1);
    }

    atexit(SDL_Quit);    
 
    SDL_VideoDriverName(tmpstr, 255);
	fprintf(stderr,"Video Driver: %s\n",tmpstr);

    InitFont();  //��ʼ��
    
	r=SDL_InitSubSystem(SDL_INIT_AUDIO);
    if(r<0)
        g_EnableSound=0;

    r=Mix_OpenAudio(MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT, 2, 4096);

   if( r < 0 ) {
        fprintf(stderr,
                "Couldn't initialize SDL_Mixer: %s\n", SDL_GetError());
        g_EnableSound=0;
    }

	currentWav=0;

    for(i=0;i<WAVNUM;i++)
         WavChunk[i]=NULL;

    return 0;
}

// �˳�SDL
int ExitSDL(void)
{
	int i;

    ExitFont();

    StopMIDI();

    for(i=0;i<WAVNUM;i++){
		if(WavChunk[i]){
             Mix_FreeChunk(WavChunk[i]);
		     WavChunk[i]=NULL;
		}
	}

	Mix_CloseAudio();

    JY_LoadPicture("",0,0);    // �ͷſ��ܼ��ص�ͼƬ����

    return 0;
}

// ת��0RGB����ǰ��Ļ��ɫ
Uint32 ConvertColor(Uint32 color){
   Uint8 *p=(Uint8*)&color;
   return SDL_MapRGB(g_Surface->format,*(p+2),*(p+1),*p);
}    


// ��ʼ����Ϸ����
int InitGame(void)
{

    if(g_FullScreen==0)
        g_Surface=SDL_SetVideoMode(g_ScreenW,g_ScreenH, 0, SDL_SWSURFACE);
	else
	    g_Surface=SDL_SetVideoMode(g_ScreenW, g_ScreenH, g_ScreenBpp, SDL_HWSURFACE|SDL_DOUBLEBUF|SDL_FULLSCREEN);


	if(g_Surface==NULL)
		fprintf(stderr,"Cannot set video mode");

    Init_Cache();
	
    JY_PicInit("");        // ��ʼ����ͼcache

    return 0;
}


// �ͷ���Ϸ��Դ
int ExitGame(void)
{

    JY_PicInit("");
    
    JY_LoadPicture("",0,0);

    JY_UnloadMMap();     //�ͷ�����ͼ�ڴ�

	JY_UnloadSMap();     //�ͷų�����ͼ�ڴ�

    JY_UnloadWarMap();   //�ͷ�ս����ͼ�ڴ�

    return 0;
}


//����ͼ���ļ���������ʽҲ���Լ���
//x,y =-1 ����ص���Ļ����
//    ���δ���أ�����أ�Ȼ��blit��������أ�ֱ��blit
//  str �ļ��������Ϊ�գ����ͷű���        
int JY_LoadPicture(const char* str,int x,int y)
{
    static char filename[255]="\0";   		
	static SDL_Surface *pic=NULL;

	SDL_Surface *tmppic;
	SDL_Rect r;

	if(strlen(str)==0){        // Ϊ�����ͷű���
        if(pic){
		    SDL_FreeSurface(pic);
            pic=NULL;
        }
		return 0;
	}
	
    if(strcmp(str,filename)!=0){ // ����ǰ�ļ�����ͬ�����ͷ�ԭ�����棬�����±���
        if(pic){
		    SDL_FreeSurface(pic);
            pic=NULL;
        }
        tmppic = IMG_Load(str);
        if(tmppic){
		    pic=SDL_DisplayFormat(tmppic);   // ��Ϊ��ǰ��������ظ�ʽ
 		    SDL_FreeSurface(tmppic);
            strcpy(filename,str);
        }
	}

	if(pic){
        if( (x==-1) && (y==-1) ){
			x=(g_ScreenW-pic->w)/2;
			y=(g_ScreenH-pic->h)/2;
		}
	    r.x=x;
	    r.y=y;
        SDL_BlitSurface(pic, NULL, g_Surface, &r);

	}
	else{
        fprintf(stderr,"JY_LoadPicture: Load picture file %s failed!",str);
	}

	return 0;
}



//��ʾ����
int JY_ShowSurface()
{
	SDL_Flip(g_Surface);
	return 0;
}

//��ʱx����
int JY_Delay(int x)
{
    SDL_Delay(x);
    return 0;
}


// ������ʾͼ�� 
// delaytime ÿ�ν�����ʱ������
// Flag=0 �Ӱ�������1����������
int JY_ShowSlow(int delaytime,int Flag)
{
    int i;
	int step;
	int t1,t2;
	int alpha;

 
    SDL_Surface* lps1;  // ������ʱ����
	lps1=SDL_CreateRGBSurface(SDL_SWSURFACE,g_Surface->w,g_Surface->h,g_Surface->format->BitsPerPixel,
		                      g_Surface->format->Rmask,g_Surface->format->Gmask,g_Surface->format->Bmask,0);

	if(lps1==NULL){
		fprintf(stderr,"JY_ShowSlow: Create surface failed!");
		return 1;
	}

	SDL_BlitSurface(g_Surface ,NULL,lps1,NULL);    //��ǰ���渴�Ƶ���ʱ����

	for(i=0;i<=32;i++)
	{
        if(Flag==0)
			step=i;
	    else
			step=32-i;

        t1=JY_GetTime();
 
        SDL_FillRect(g_Surface,NULL,0);          //��ǰ������

        alpha=step<<3;
		if(alpha>255) 
			alpha=255;

        SDL_SetAlpha(lps1,SDL_SRCALPHA,(Uint8)alpha);  //����alpha

		SDL_BlitSurface(lps1 ,NULL,g_Surface,NULL); 

        JY_ShowSurface();

        t2=JY_GetTime();
		if(delaytime > t2-t1)
			JY_Delay(delaytime-(t2-t1));
	}

    SDL_FreeSurface(lps1);       //�ͷű���
 
	return 0;
}

//�õ���ǰʱ�䣬��λ����
int JY_GetTime()
{
    return SDL_GetTicks();
}

//��������
int JY_PlayMIDI(const char *filename)
{
	static char currentfile[255]="\0";

    if(g_EnableSound==0)
		return 1;

	if(strlen(filename)==0){  //�ļ���Ϊ�գ�ֹͣ����
        StopMIDI();
        strcpy(currentfile,filename);
		return 0;
	}
	
	if(strcmp(currentfile,filename)==0) //�뵱ǰ�����ļ���ͬ��ֱ�ӷ���
		return 0;

    StopMIDI();
	
	currentMusic=Mix_LoadMUS(filename);

	if(currentMusic==NULL){
		fprintf(stderr,"Open music file %s failed!",filename);
		return 1;
	}

	Mix_VolumeMusic(g_MusicVolume);

	Mix_PlayMusic(currentMusic, -1);

    strcpy(currentfile,filename);

	return 0;
}

//ֹͣ��Ч
int StopMIDI()
{
    if(currentMusic!=NULL){
		Mix_HaltMusic();
		Mix_FreeMusic(currentMusic);
		currentMusic=NULL;
	}
    return 0;
}


//������Ч
int JY_PlayWAV(const char *filename)
{
	
    if(g_EnableSound==0)
		return 1;    

	if(WavChunk[currentWav]){          //�ͷŵ�ǰ��Ч
        Mix_FreeChunk(WavChunk[currentWav]);
        WavChunk[currentWav]=NULL;
	}

	WavChunk[currentWav]= Mix_LoadWAV(filename);  //���ص���ǰ��Ч

	if(WavChunk[currentWav]){
        Mix_VolumeChunk(WavChunk[currentWav],g_SoundVolume);
        Mix_PlayChannel(-1, WavChunk[currentWav], 0);  //������Ч
		currentWav++;
		if(currentWav>=WAVNUM)
			currentWav=0;
	}
	else{
		fprintf(stderr,"Open wav file %s failed!",filename);
	}

	return 0;
}


// �õ�ǰ�水�µ��ַ�
int JY_GetKey()
{
    SDL_Event event;
	int keyPress=-1;
    while(SDL_PollEvent(&event)){   
		switch(event.type){   
        case SDL_KEYDOWN:  
            keyPress=event.key.keysym.sym;
            break;
        case SDL_MOUSEMOTION:
            break;
        default: 
            break;
        }
	}	
	return keyPress;
}


//���òü�
int JY_SetClip(int x1,int y1,int x2,int y2)
{
    SDL_Rect r;
	if (x1==0 && y1==0 && x2==0 && y2==0){
		SDL_SetClipRect(g_Surface,NULL);
	}
    else{
        r.x=x1;
		r.y=y1;
		r.w=x2-x1;
		r.h=y2-y1;
        SDL_SetClipRect(g_Surface,&r);
	}

    return 0;
}


// ���ƾ��ο�
// (x1,y1)--(x2,y2) ������ϽǺ����½�����
// color ��ɫ
int JY_DrawRect(int x1,int y1,int x2,int y2,int color)
{
    Uint8 *p ;
	int lpitch=0;
	Uint32 c;
 
    SDL_LockSurface(g_Surface);
    p=g_Surface->pixels;
	lpitch=g_Surface->pitch;

	c=ConvertColor(color);
	HLine32(x1,x2,y1,c,p,lpitch);
	HLine32(x1,x2,y2,c,p,lpitch);
 	VLine32(y1,y2,x1,c,p,lpitch); 
  	VLine32(y1,y2,x2,c,p,lpitch); 
 
    SDL_UnlockSurface(g_Surface);
 
	return 0;
}


//��ˮƽ��
void HLine32(int x1,int x2,int y,int color, unsigned char *vbuffer, int lpitch)
{
 
    int temp; 
    int i;
    int max_x,max_y,min_x,min_y;
    Uint8 *vbuffer2;
	int bpp;

	bpp=g_Surface->format->BytesPerPixel;

    //�ֹ�����
    min_x=g_Surface->clip_rect.x;
	min_y=g_Surface->clip_rect.y;
	max_x=g_Surface->clip_rect.x+g_Surface->clip_rect.w-1;
    max_y=g_Surface->clip_rect.y+g_Surface->clip_rect.h-1;

    if (y > max_y || y < min_y)
        return;
 
    if (x1>x2){
       temp = x1;
       x1   = x2;
       x2   = temp;
    } 

    if (x1 > max_x || x2 < min_x)
        return;

    x1 = ((x1 < min_x) ? min_x : x1);
    x2 = ((x2 > max_x) ? max_x : x2);

 
    vbuffer2=vbuffer+y*lpitch+x1*bpp;
	switch(bpp){
	case 2:        //16λɫ��
		for(i=0;i<=x2-x1;i++){
			*(Uint16*)vbuffer2=(Uint16)color;
			vbuffer2+=2;
		}
        break; 
	case 3:        //24λɫ��
		for(i=0;i<=x2-x1;i++){
			*(Uint16*)vbuffer2=(Uint16)color;
			vbuffer2+=2;
			*vbuffer2=(color & 0xff0000)>>16;
			vbuffer2++;
		}
        break; 
	case 4:        //32λɫ��
		for(i=0;i<=x2-x1;i++){
			*(Uint32*)vbuffer2=(Uint32)color;
			vbuffer2+=4;
		}
        break; 
    }
}  

//�洹ֱ��
void VLine32(int y1,int y2,int x,int color, unsigned char *vbuffer, int lpitch)
{
 
    int temp; 
    int i;
    int max_x,max_y,min_x,min_y;
    Uint8 *vbuffer2;
	int bpp;

	bpp=g_Surface->format->BytesPerPixel;

    min_x=g_Surface->clip_rect.x;
	min_y=g_Surface->clip_rect.y;
	max_x=g_Surface->clip_rect.x+g_Surface->clip_rect.w-1;
    max_y=g_Surface->clip_rect.y+g_Surface->clip_rect.h-1;


    if (x > max_x || x < min_x)
        return;
 
    if (y1>y2){
       temp = y1;
       y1   = y2;
       y2   = temp;
    } 

    if (y1 > max_y || y2 < min_y)
        return;

    y1 = ((y1 < min_y) ? min_y : y1);
    y2 = ((y2 > max_y) ? max_y : y2);

    vbuffer2=vbuffer+y1*lpitch+x*bpp;
	switch(bpp){
	case 2:
		for(i=0;i<=y2-y1;i++){
			*(Uint16*)vbuffer2=(Uint16)color;
			vbuffer2+=lpitch;
		}
        break; 
	case 3:
		for(i=0;i<=y2-y1;i++){
			*(Uint16*)vbuffer2=(Uint16)color;
			*(vbuffer2+2)=(color & 0xff0000)>>16;
			vbuffer2+=lpitch;
		}
        break; 
	case 4:
		for(i=0;i<=y2-y1;i++){
			*(Uint32*)vbuffer2=(Uint32)color;
			vbuffer2+=lpitch;
		}
        break; 
    }

}  



// ͼ�����
// ���x1,y1,x2,y2��Ϊ0���������������
// color, ���ɫ����RGB��ʾ���Ӹߵ����ֽ�Ϊ0RGB
int JY_FillColor(int x1,int y1,int x2,int y2,int color)
{
	int c=ConvertColor(color);

    SDL_Rect rect;
   
	if(x1==0 || y1==0 || x2==0 || y2==0){
        SDL_FillRect(g_Surface,NULL,c);
	}
	else{
		rect.x=x1;
		rect.y=y1;
		rect.w=x2-x1+1;
		rect.h=y2-y1+1;

		SDL_FillRect(g_Surface,&rect,c);
	}

	return 0;

}


// �ѱ���blt����������ǰ������
// x,y Ҫ���ص���������Ͻ�����
int BlitSurface(SDL_Surface* lps, int x, int y ,int flag,int value)
{

	SDL_Surface *tmps;
	SDL_Rect r;
	int i,j;

    Uint32 color=ConvertColor(g_MaskColor32);

	if(value>255)
		value=255;

	r.x=x;
	r.y=y;

	if((flag & 0x2)==0){        // û��alpla
        SDL_BlitSurface(lps,NULL,g_Surface,&r);
	}
    else{  // ��alpha
        if( (flag &0x4) || (flag &0x8)){   // �ڰ�
 		    int bpp=lps->format->BitsPerPixel;
		    //������ʱ����
    	    tmps=SDL_CreateRGBSurface(SDL_SWSURFACE,lps->w,lps->h,bpp,
		                          lps->format->Rmask,lps->format->Gmask,lps->format->Bmask,0);

		    SDL_FillRect(tmps,NULL,color);
	        SDL_SetColorKey(tmps,SDL_SRCCOLORKEY ,color);
            SDL_BlitSurface(lps,NULL,tmps,NULL);
            SDL_LockSurface(tmps);

            if(bpp==16){
                for(j=0;j<tmps->h;j++){
                    Uint16 *p=(Uint16*)((Uint8*)tmps->pixels+j*tmps->pitch);
                    for(i=0;i<tmps->w;i++){
                        if(*p!=(Uint16)color){
                            if(flag &0x4)
                                *p=0;
                            else
                                *p=0xffff;
                        }
                        p++;
                    }
                }
            }
            else if(bpp==32){
                for(j=0;j<tmps->h;j++){
                    Uint32 *p=(Uint32*)((Uint8*)tmps->pixels+j*tmps->pitch);
                    for(i=0;i<tmps->w;i++){
                        if(*p!=color){
                            if(flag &0x4)
                                *p=0;
                            else
                                *p=0xffffffff;
                        }
                        p++;
                    }
                }
            }
            else if(bpp=24){
                for(j=0;j<tmps->h;j++){
                    Uint8 *p=(Uint8*)tmps->pixels+j*tmps->pitch;
                    for(i=0;i<tmps->w;i++){
                        if((*p!=*(Uint8*)&color) &&  
                            (*(p+1) != *((Uint8*)&color+1)) &&
                            (*(p+2) != *((Uint8*)&color+2)) ){
                            if(flag &0x4){
                                *p=0;
                                *(p+1)=0;
                                *(p+2)=0;
                            }
                            else{
                                *p=0xff;
                                *(p+1)=0xff;
                                *(p+2)=0xff;
                            }
                        }
                        p+=3;
                    }
                }

            }

            SDL_UnlockSurface(tmps);

            SDL_SetAlpha(tmps,SDL_SRCALPHA,(Uint8)value);

	        SDL_BlitSurface(tmps,NULL,g_Surface,&r);

		    SDL_FreeSurface(tmps);
        }
        else{
 
            SDL_SetAlpha(lps,SDL_SRCALPHA,(Uint8)value);

	        SDL_BlitSurface(lps,NULL,g_Surface,&r);
 
        }
	}
	
	return 0;
}


// �����䰵
// ��Դ����(x1,y1,x2,y2)�����ڵ����е����Ƚ���
// bright ���ȵȼ� 0-256 
int JY_Background(int x1,int y1,int x2,int y2,int Bright)
{
    SDL_Surface* lps1; 
    SDL_Rect r; 

	if(x2<=x1 || y2<=y1) 
		return 0;

    Bright=256-Bright;
	if(Bright>255)
		Bright=255;

	lps1=SDL_CreateRGBSurface(SDL_SWSURFACE,x2-x1,y2-y1,g_Surface->format->BitsPerPixel,
		                      g_Surface->format->Rmask,g_Surface->format->Gmask,g_Surface->format->Bmask,0);


 
    SDL_FillRect(lps1,NULL,0);

    SDL_SetAlpha(lps1,SDL_SRCALPHA,(Uint8)Bright);

    r.x=x1;
	r.y=y1;

	SDL_BlitSurface(lps1,NULL,g_Surface,&r); 

	SDL_FreeSurface(lps1);
	return 1;
}

//����mpeg
// esckey ֹͣ���ŵİ���
int JY_PlayMPEG(const char* filename,int esckey)
{
     SMPEG_Info mpg_info;
     SMPEG* mpg = NULL;
	 char *err;
 
     mpg=SMPEG_new(filename,&mpg_info,0);
  
	 err=SMPEG_error(mpg);
	 if(err!=NULL){
		 fprintf(stderr,"Open file %s error: %s\n",filename,err);
		 return 1;
	 }
     

     SMPEG_setdisplay(mpg,g_Surface,NULL,NULL);
 
	 /* Play the movie, using SDL_mixer for audio */
	 SMPEG_enableaudio(mpg, 0);
	 if (g_EnableSound==1) {
		SDL_AudioSpec audiofmt;
		Uint16 format;
		int freq, channels;

		/* Tell SMPEG what the audio format is */
		Mix_QuerySpec(&freq, &format, &channels);
		audiofmt.format = format;
		audiofmt.freq = freq;
		audiofmt.channels = channels;
		SMPEG_actualSpec(mpg, &audiofmt);

		/* Hook in the MPEG music mixer */
		Mix_HookMusic(SMPEG_playAudioSDL, mpg);
		SMPEG_enableaudio(mpg, 1);
	}

     SMPEG_play(mpg);
  
     while( (SMPEG_status(mpg) == SMPEG_PLAYING)){
	     int key=JY_GetKey();
		 if(key==esckey){
             break;
		 }
         SDL_Delay(500);
	 }
 
    SMPEG_stop(mpg);
    SMPEG_delete(mpg);
    Mix_HookMusic(NULL, NULL);
	return 0;
} 


// ȫ���л�
int JY_FullScreen()
{    
    SDL_Surface *tmpsurface;

	Uint32 flag=g_Surface->flags;

	tmpsurface=SDL_CreateRGBSurface(SDL_SWSURFACE,g_Surface->w,g_Surface->h,g_Surface->format->BitsPerPixel,
		                      g_Surface->format->Rmask,g_Surface->format->Gmask,g_Surface->format->Bmask,0);

    SDL_BlitSurface(g_Surface,NULL,tmpsurface,NULL);

	if(flag & SDL_FULLSCREEN)    //ȫ�������ô���
        g_Surface=SDL_SetVideoMode(g_ScreenW,g_ScreenH, 0, SDL_SWSURFACE);
	else
	    g_Surface=SDL_SetVideoMode(g_ScreenW, g_ScreenH, g_ScreenBpp, SDL_HWSURFACE|SDL_DOUBLEBUF|SDL_FULLSCREEN);


	SDL_BlitSurface(tmpsurface,NULL,g_Surface,NULL);

    JY_ShowSurface();

	SDL_FreeSurface(tmpsurface);
  
	return 0;
}