
// ������
// ������Ϊ��Ӿ�����д��
// ��Ȩ���ޣ����������κη�ʽʹ�ô���
  
 
#include <stdio.h>
#include <time.h>

#include "jymain.h"

// ȫ�̱���

SDL_Surface* g_Surface=NULL;    // ��Ϸʹ�õ���Ƶ����
Uint32 g_MaskColor32=0x706020;      // ͸��ɫ

int g_ScreenW=640 ;          // ��Ļ���
int g_ScreenH=480 ;
int g_ScreenBpp=16 ;         // ��Ļɫ��
int g_FullScreen=0;
int g_EnableSound=1;         // �������� 0 �ر� 1 ��
int g_MusicVolume=32;           // ����������С
int g_SoundVolume=32;           // ��Ч������С

int g_XScale=18;             //��ͼx,y����һ���С
int g_YScale=9;

//������ͼ����ʱxy������Ҫ����Ƶ���������֤����ȫ����ʾ
int g_MMapAddX;              
int g_MMapAddY;
int g_SMapAddX;
int g_SMapAddY;
int g_WMapAddX;
int g_WMapAddY;

int g_MAXCacheNum=1000;     //��󻺴�����

int g_LoadFullS=1;          //�Ƿ�ȫ������S�ļ�


static int IsDebug=0;         //�Ƿ�򿪸����ļ�

static char JYMain_Lua[255];  //lua������

//�����lua�ӿں�����
static const struct luaL_reg jylib [] = {
      {"Debug", HAPI_Debug},

      {"GetKey", HAPI_GetKey},
      {"EnableKeyRepeat", HAPI_EnableKeyRepeat},

      {"Delay", HAPI_Delay},
      {"GetTime", HAPI_GetTime},
  
      {"CharSet", HAPI_CharSet},
      {"DrawStr", HAPI_DrawStr},

      
      {"SetClip",HAPI_SetClip},
      {"FillColor", HAPI_FillColor},
      {"Background", HAPI_Background},
      {"DrawRect", HAPI_DrawRect},

      {"ShowSurface", HAPI_ShowSurface},
      {"ShowSlow", HAPI_ShowSlow},

      {"PicInit", HAPI_PicInit},
      {"PicGetXY", HAPI_GetPicXY},
      {"PicLoadCache", HAPI_LoadPic},
      {"PicLoadFile", HAPI_PicLoadFile},

      {"FullScreen", HAPI_FullScreen},

      {"LoadPicture", HAPI_LoadPicture},

      {"PlayMIDI", HAPI_PlayMIDI},
      {"PlayWAV", HAPI_PlayWAV},
      {"PlayMPEG", HAPI_PlayMPEG},
      
	  {"LoadMMap", HAPI_LoadMMap},
      {"DrawMMap", HAPI_DrawMMap},
      {"GetMMap", HAPI_GetMMap},
	  {"UnloadMMap", HAPI_UnloadMMap},
 
      {"LoadSMap", HAPI_LoadSMap},
      {"SaveSMap", HAPI_SaveSMap},
      {"GetS", HAPI_GetS},
      {"SetS", HAPI_SetS},
      {"GetD", HAPI_GetD},
      {"SetD", HAPI_SetD},
      {"DrawSMap", HAPI_DrawSMap},

      {"LoadWarMap", HAPI_LoadWarMap},
      {"GetWarMap", HAPI_GetWarMap},
      {"SetWarMap", HAPI_SetWarMap},
      {"CleanWarMap", HAPI_CleanWarMap},

      {"DrawWarMap", HAPI_DrawWarMap},
      {"DrawWarNum", HAPI_DrawWarNum},

      {NULL, NULL}
    };
 
 

static const struct luaL_reg bytelib [] = {
      {"create", Byte_create},
      {"loadfile", Byte_loadfile},
      {"savefile", Byte_savefile},
      {"get16", Byte_get16},
      {"set16", Byte_set16},
      {"getu16", Byte_getu16},
      {"setu16", Byte_setu16},
      {"get32", Byte_get32},
      {"set32", Byte_set32},
      {"getstr", Byte_getstr},
      {"setstr", Byte_setstr},
	  {NULL, NULL}
};



// ������
int main(int argc, char *argv[])
{
    remove("debug.txt");
    freopen("error.txt","wt",stderr);    //����stderr������ļ�

    Lua_Config();        //��ȡlua�����ļ������ò���

    InitSDL();           //��ʼ��SDL

	InitGame();          //��ʼ����Ϸ����

	LoadMB("hzmb.dat");  //���غ����ַ���ת�����

    Lua_Main();          //����Lua����������ʼ��Ϸ
 
	ExitGame();       //�ͷ���Ϸ����
 
    ExitSDL();        //�˳�SDL
 
    return 0;
}


//Lua������
int Lua_Main(void)
{
    lua_State *pL_main;
	int result=0; 

	//��ʼ��lua
	 pL_main=lua_open();
    luaL_openlibs(pL_main);
 
    //ע��lua����
    luaL_register(pL_main,"lib", jylib);
    luaL_register(pL_main, "Byte", bytelib);
 

	//����lua�ļ�
    result=luaL_loadfile(pL_main,JYMain_Lua);
    switch(result){
    case LUA_ERRSYNTAX:
        fprintf(stderr,"load lua file %s error: syntax error!\n",JYMain_Lua);
        break;
    case LUA_ERRMEM:
        fprintf(stderr,"load lua file %s error: memory allocation error!\n",JYMain_Lua);
        break;
    case LUA_ERRFILE:
        fprintf(stderr,"load lua file %s error: can not open file!\n",JYMain_Lua);
        break;    
    }
    
	result=lua_pcall(pL_main, 0, LUA_MULTRET, 0);
    
    //����lua��������JY_Main    
   	lua_getglobal(pL_main,"JY_Main");
	result=lua_pcall(pL_main,0,0,0);

 
    //�ر�lua
    lua_close(pL_main);

	return 0;
}


//Lua��ȡ������Ϣ
int Lua_Config(void)
{
    char *filename="config.lua";
	int result=0; 

	//��ʼ��lua
	lua_State *pL=lua_open();
    luaL_openlibs(pL);
 
	//����lua�����ļ�
    result=luaL_loadfile(pL,filename);
    switch(result){
    case LUA_ERRSYNTAX:
        fprintf(stderr,"load lua file %s error: syntax error!\n",filename);
        break;
    case LUA_ERRMEM:
        fprintf(stderr,"load lua file %s error: memory allocation error!\n",filename);
        break;
    case LUA_ERRFILE:
        fprintf(stderr,"load lua file %s error: can not open file!\n",filename);
        break;    
    }

	result=lua_pcall(pL, 0, LUA_MULTRET, 0);

    lua_getglobal(pL,"CONFIG");            //��ȡconfig�����ֵ
	g_ScreenW=getfield(pL,"Width");
	g_ScreenH= getfield(pL, "Height");
	g_ScreenBpp=  getfield(pL, "bpp");
	g_FullScreen= getfield(pL, "FullScreen");
	g_XScale=  getfield(pL, "XScale");
 	g_YScale=  getfield(pL, "YScale");
    g_EnableSound =getfield(pL, "EnableSound");
    IsDebug =getfield(pL, "Debug");
    g_MMapAddX =getfield(pL, "MMapAddX");
    g_MMapAddY =getfield(pL, "MMapAddY");
    g_SMapAddX =getfield(pL, "SMapAddX");
    g_SMapAddY =getfield(pL, "SMapAddY");
    g_WMapAddX =getfield(pL, "WMapAddX");
    g_WMapAddY =getfield(pL, "WMapAddY");
    g_SoundVolume =getfield(pL, "SoundVolume");
    g_MusicVolume =getfield(pL, "MusicVolume");

    g_MAXCacheNum =getfield(pL, "MAXCacheNum");
    g_LoadFullS =getfield(pL, "LoadFullS");
  
 
    getfieldstr(pL,"JYMain_Lua",JYMain_Lua);

    //�ر�lua
    lua_close(pL);

	return 0;
}


//��ȡlua���е�����
int getfield(lua_State *pL,const char *key)
{
	int result;
	lua_getfield(pL,-1,key);
	result=(int)lua_tonumber(pL,-1);
	lua_pop(pL,1);
	return result;
}

//��ȡlua���е��ַ���
int getfieldstr(lua_State *pL,const char *key,char *str)
{
 
	const char *tmp;
	lua_getfield(pL,-1,key);
	tmp=(const char *)lua_tostring(pL,-1);
	strcpy(str,tmp); 
	lua_pop(pL,1);
	return 0;
}




//����Ϊ����ͨ�ú���



// ���Ժ���
// �����debug.txt��
int JY_Debug(const char * str)
{
    time_t t;
	FILE *fp;
    struct tm *newtime;
 
    if(IsDebug==0)
        return 0;

	fp=fopen("debug.txt","a+t");
	time(&t);
    newtime=localtime(&t);
	fprintf(fp,"%02d:%02d:%02d %s\n",newtime->tm_hour,newtime->tm_min,newtime->tm_sec,str);
 	fclose(fp);
	return 0;
}

 

// ����x��С
int limitX(int x, int xmin, int xmax)
{
    if(x>xmax)
		x=xmax;
	if(x<xmin)
		x=xmin;
	return x;
}



// �����ļ����ȣ���Ϊ0�����ļ����ܲ�����
int FileLength(const char *filename)
{
    FILE   *f;  
    int ll;
    if((f=fopen(filename,"rb"))==NULL){
        return 0;            // �ļ������ڣ�����
	}
    fseek(f,0,SEEK_END);  
    ll=ftell(f);    //����õ���len�����ļ��ĳ�����
    fclose(f);   
	return ll;
}



