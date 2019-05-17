
//绘制主地图、场景地图和战斗地图
//为加快速度，这些函数改为c中实现

 
#include "jymain.h"

 
//主地图数据
static short *pEarth=NULL;
static short *pSurface=NULL;
static short *pBuilding=NULL;
static short *pBuildX=NULL;
static short *pBuildY=NULL;

static int XMax,YMax;  //主地图大小
 
static int BuildNumber;     //实际排序个数

static BuildingType Build[2000];        // 建筑排序数组
  
static int S_XMax,S_YMax;      // 场景地图大小
static int S_Num;
static Sint16 *pS=NULL;              // 场景S*数据

// 为减少内存占用，对S文件采用临时文件方式访问，只在内存中保存当前场景的S数据
static char TempS_filename[255];     //临时S文件名
static int currentS=-1;              //当前加载的场景S数据

static int D_Num1;             // 每个场景D的个数
static int D_Num2;             // 每个D的数据个数

static Sint16 *pD=NULL;              // 场景D*数据

static int War_XMax,War_YMax;      // 战斗地图大小
static int War_Num;                // 战斗地图层数
static Sint16 *pWar=NULL;           // 战斗地图数据

 
extern int g_ScreenW;
extern int g_ScreenH;

extern int g_XScale;
extern int g_YScale;  

extern int g_MMapAddX;
extern int g_MMapAddY;
extern int g_SMapAddX;
extern int g_SMapAddY;
extern int g_WMapAddX;
extern int g_WMapAddY;

extern int g_LoadFullS;


// 读取主地图数据
int JY_LoadMMap(const char* earthname, const char* surfacename, const char*buildingname,
				const char* buildxname, const char* buildyname, int x_max, int y_max)
{
    FILE *fp;

    XMax=x_max;
	YMax=y_max;

    JY_UnloadMMap();
	//读取earth文件
    pEarth=(Uint16*) malloc(XMax*YMax*2);

	if((fp=fopen(earthname,"rb"))==NULL){
        fprintf(stderr,"file not open ---%s",earthname);
		return 1;
	}
    fread(pEarth,2,XMax*YMax,fp);
	fclose(fp);

	//读取surface文件
    pSurface=(Uint16*) malloc(XMax*YMax*2);

	if((fp=fopen(surfacename,"rb"))==NULL){
        fprintf(stderr,"file not open ---%s",surfacename);
		return 0;
	}
    fread(pSurface,2,XMax*YMax,fp);
	fclose(fp); 

	//读取building文件
    pBuilding=(Uint16*) malloc(XMax*YMax*2);

	if((fp=fopen(buildingname,"rb"))==NULL){
        fprintf(stderr,"file not open ---%s",buildingname);
		return 0;
	}
    fread(pBuilding,2,XMax*YMax,fp);
	fclose(fp); 

	//读取building文件
    pBuildX=(Uint16*) malloc(XMax*YMax*2);

	if((fp=fopen(buildxname,"rb"))==NULL){
        fprintf(stderr,"file not open ---%s",buildxname);
		return 0;
	}
    fread(pBuildX,2,XMax*YMax,fp);
	fclose(fp); 

	//读取building文件
    pBuildY=(Uint16*) malloc(XMax*YMax*2);

	if((fp=fopen(buildyname,"rb"))==NULL){
        fprintf(stderr,"file not open ---%s",buildyname);
		return 0;
	}
    fread(pBuildY,2,XMax*YMax,fp);
	fclose(fp); 

	return 0;
}

// 释放主地图数据
int JY_UnloadMMap(void)
{
    
    SafeFree(pEarth);
    SafeFree(pSurface);
    SafeFree(pBuilding);
    SafeFree(pBuildX);
    SafeFree(pBuildY);

    return 0;
}


// 取主地图数据 
// flag  0 earth, 1 surface, 2 building, 3 buildx, 4 buildy
int JY_GetMMap(int x, int y , int flag)
{
	int s=y*XMax+x;
	int v;
	switch(flag)
	{
	case 0:
        v=pEarth[s];
		break;
	case 1:
        v=pSurface[s];
		break;
	case 2:
        v=pBuilding[s];
		break;
	case 3:
        v=pBuildX[s];
		break;
	case 4:
        v=pBuildY[s];
		break;
   }
	return v;

}

// 存主地图数据 
// flag  0 earth, 1 surface, 2 building, 3 buildx, 4 buildy
int JY_SetMMap(short x, short y , int flag, short v)
{
	int s=y*XMax+x;
 
	switch(flag)
	{
	case 0:
        pEarth[s]=v;
		break;
	case 1:
        pSurface[s]=v;
		break;
	case 2:
        pBuilding[s]=v;
		break;
	case 3:
        pBuildX[s]=v;
		break;
	case 4:
        pBuildY[s]=v;
		break;
   }
	return 0;
}


// 主地图建筑排序 
// x,y 主角坐标
// Mypic 主角贴图编号
int BuildingSort(short x, short y, short Mypic)
{

    int rangex=g_ScreenW/(2*g_XScale)/2+1+g_MMapAddX;
	int rangey=g_ScreenH/(2*g_YScale)/2+1;

	int range=rangex+rangey+g_MMapAddY;

	short bak=JY_GetMMap(x,y,2);
	short bakx=JY_GetMMap(x,y,3);
	short baky=JY_GetMMap(x,y,4);
    
	int xmin=limitX(x-range,1,XMax-1);
	int xmax=limitX(x+range,1,XMax-1);
	int ymin=limitX(y-range,1,YMax-1);
	int ymax=limitX(y+range,1,YMax-1);

    int i,j,k,m;
    int dy;
	int repeat=0;
	int p=0;

	BuildingType tmpBuild;

    JY_SetMMap(x,y,2,(short)(Mypic*2));
    JY_SetMMap(x,y,3,x);
    JY_SetMMap(x,y,4,y);

	for(i=xmin;i<=xmax;i++){
		dy=ymin;
		for(j=ymin;j<=ymax;j++){
			int ij3=JY_GetMMap(i,j,3);
			int ij4=JY_GetMMap(i,j,4);
			if( (ij3!=0) && (ij4!=0)){
				repeat=0;
				for(k=0;k<p;k++){
					if((Build[k].x ==ij3) && (Build[k].y==ij4)){
						repeat =1;
						if(k==p-1)
							break;

						for(m=j-1;m>=dy;m--){
							int im3=JY_GetMMap(i,m,3);
							int im4=JY_GetMMap(i,m,4);
							if( (im3!=0) && (im4!=0)){
								if( (im3!=ij3) || (im4!=ij4)){
								    if( (im3!=Build[k].x) || (im4!=Build[k].y)){
										tmpBuild=Build[p-1];
										memmove(&Build[k+1],&Build[k],(p-2-k+1)*sizeof(BuildingType));
										Build[k]=tmpBuild;										 
									}
								}
							}
						}
						dy=j+1;
						break;
					}
				}

				if(repeat==0){
					Build[p].x =ij3;
					Build[p].y =ij4;
					Build[p].num =JY_GetMMap(Build[p].x,Build[p].y,2);
					p++;
				}
			}
		}
	}

    BuildNumber=p;

    JY_SetMMap(x,y,2,bak);
    JY_SetMMap(x,y,3,bakx);
    JY_SetMMap(x,y,4,baky);   

    return 0;
}



// 绘制主地图
int JY_DrawMMap(int x, int y, int Mypic)
{
    int rangex=g_ScreenW/(2*g_XScale)/2+1+g_MMapAddX;
	int rangey=g_ScreenH/(2*g_YScale)/2+1;
	int i,j;
	int i1,j1;
	int x1,y1;
    int picnum;

	JY_FillColor(0,0,0,0,0);

    BuildNumber=0;
    BuildingSort((short)x, (short)y, (short)Mypic);
  
 	for(j=0;j<=2*2*rangey+g_MMapAddY;j++){
	    for(i=-rangex;i<=rangex;i++){
			if(j%2==0){
                i1=i+j/2-rangey;
				j1=-i+j/2-rangey;
			}
			else{
                i1=i+j/2-rangey;
				j1=-i+j/2+1-rangey;
			}
             
            x1=g_XScale*(i1-j1)+g_ScreenW/2;
			y1=g_YScale*(i1+j1)+g_ScreenH/2;

			if( ((x+i1)>=0) && ((x+i1)<XMax) && ((y+j1)>=0) && ((y+j1)<YMax) ){
				picnum=JY_GetMMap(x+i1,y+j1,0);
				if(picnum>0)
                    JY_LoadPic(0,picnum,x1,y1,0,0);
				picnum=JY_GetMMap(x+i1,y+j1,1);
				if(picnum>0)
                    JY_LoadPic(0,picnum,x1,y1,0,0);
                     		
			}
		}
	}

	for(i=0;i<BuildNumber;i++){
        i1=Build[i].x -x;
		j1=Build[i].y -y;
        x1=g_XScale*(i1-j1)+g_ScreenW/2;
	    y1=g_YScale*(i1+j1)+g_ScreenH/2;
		picnum=Build[i].num ;
		if(picnum>0){
			JY_LoadPic(0,picnum,x1,y1,0,0);
		}
	}
     return 0;
}


//读取S*D*
int JY_LoadSMap(const char *Sfilename,const char*tmpfilename, int num,int x_max,int y_max,
				const char *Dfilename,int d_num1,int d_num2)
{
    FILE *fp,*fp2;
    int i; 

    S_XMax=x_max;
	S_YMax=y_max;
    S_Num=num;

	//读取S文件
    if(g_LoadFullS==0){     //读取s到临时文件
        strcpy(TempS_filename,tmpfilename);  
        if(pS==NULL)
            pS=(Uint16*) malloc(S_XMax*S_YMax*6*2);

	    if(pS==NULL){
		    fprintf(stderr,"JY_LoadSMap error: can not malloc memory\n");
		    return 0;
	    }

	    if((fp=fopen(Sfilename,"rb"))==NULL){
            fprintf(stderr,"JY_LoadSMap error:file not open ---%s",Sfilename);
		    return 0;
	    }
	    if((fp2=fopen(TempS_filename,"wb"))==NULL){
            fprintf(stderr,"JY_LoadSMap error:file not open ---%s",TempS_filename);
		    return 0;
	    }
        for(i=0;i<S_Num;i++){
            fread(pS,2,S_XMax*S_YMax*6,fp);
            fwrite(pS,2,S_XMax*S_YMax*6,fp2);
        }
	    fclose(fp);
        fclose(fp2);
        currentS=-1;
    }
    else{      //全部读入内存
        if(pS==NULL)
            pS=(Uint16*) malloc(S_XMax*S_YMax*6*2*S_Num);

	    if(pS==NULL){
		    fprintf(stderr,"JY_LoadSMap error: can not malloc memory\n");
		    return 0;
	    }

	    if((fp=fopen(Sfilename,"rb"))==NULL){
            fprintf(stderr,"JY_LoadSMap error:file not open ---%s",Sfilename);
		    return 0;
	    }
        fread(pS,2,S_XMax*S_YMax*6*S_Num,fp); 
	    fclose(fp);
    }
        
    D_Num1=d_num1;
	D_Num2=d_num2;
	
    //读取D文件
  

	if(pD==NULL)
        pD=(Uint16*) malloc(D_Num1*D_Num2*S_Num*2);
	if(pD==NULL){
		fprintf(stderr,"JY_LoadSMap error: can not malloc memory\n");
		return 0;
	}

	if((fp=fopen(Dfilename,"rb"))==NULL){
        fprintf(stderr,"JY_LoadSMap error:file not open ---%s",Dfilename);
		return 0;
	}
    fread(pD,2,D_Num1*D_Num2*S_Num,fp);
	fclose(fp);

    return 0;
}

//保存S*D*
int JY_SaveSMap(const char *Sfilename,const char *Dfilename)
{
    FILE *fp,*fp2;
    int i; 
    
	if(pS==NULL)
		return 0;

    if(g_LoadFullS==0){    //读取部分S时的保存
        WriteS(currentS);
        currentS=-1;
	    if((fp=fopen(Sfilename,"wb"))==NULL){
            fprintf(stderr,"file not open ---%s",Sfilename);
		    return 0;
	    }
	    if((fp2=fopen(TempS_filename,"rb"))==NULL){
            fprintf(stderr,"JY_LoadSMap error:file not open ---%s",TempS_filename);
		    return 0;
	    }
        for(i=0;i<S_Num;i++){
            fread(pS,2,S_XMax*S_YMax*6,fp2);
            fwrite(pS,2,S_XMax*S_YMax*6,fp);
        }
	    fclose(fp);
        fclose(fp2);
    }
    else{
	    if((fp=fopen(Sfilename,"wb"))==NULL){
            fprintf(stderr,"file not open ---%s",Sfilename);
		    return 0;
	    }
 
        fwrite(pS,2,S_XMax*S_YMax*6*S_Num,fp);
 	    fclose(fp);
    }


	if(pD==NULL)
		return 0;
    
	if((fp=fopen(Dfilename,"wb"))==NULL){
        fprintf(stderr,"file not open ---%s",Dfilename);
		return 0;
	}
 
    fwrite(pD,2,D_Num1*D_Num2*S_Num,fp);
    fclose(fp);

    return 0;
}

int JY_UnloadSMap()
{
	SafeFree(pS);
	SafeFree(pD);

    return 0;
}

//从临时文件中读取场景id的S数据到内存
int ReadS(int id)
{
    FILE *fp;
    if(id<0 || id>=S_Num)
        return 1;

	if((fp=fopen(TempS_filename,"rb"))==NULL){
        fprintf(stderr,"JY_LoadSMap error:file not open ---%s",TempS_filename);
		return 0;
	}
    fseek(fp,S_XMax*S_YMax*6*2*id,SEEK_SET);
    fread(pS,2,S_XMax*S_YMax*6,fp);
 	fclose(fp);
    
    return 0;
}

//从内存中写入场景id的S数据到临时文件
int WriteS(int id)
{
    FILE *fp;
    if(id<0 || id>=S_Num)
        return 1;

	if((fp=fopen(TempS_filename,"r+b"))==NULL){
        fprintf(stderr,"JY_LoadSMap error:file not open ---%s",TempS_filename);
		return 0;
	}
    fseek(fp,S_XMax*S_YMax*6*2*id,SEEK_SET);
    fwrite(pS,2,S_XMax*S_YMax*6,fp);
 	fclose(fp);
    
    return 0;
}

//取s的值
int JY_GetS(int id,int x,int y,int level)
{
    int s;
    if(id<0 || id>=S_Num){
        fprintf(stderr,"GetS error: sceneid=%d out of range!\n",id);
        return 0;
    }
    if(g_LoadFullS==0){    
        if(id!=currentS){
            WriteS(currentS);
            ReadS(id);
            currentS=id;
        }
        s=S_XMax*S_YMax*level+y*S_XMax+x;
    }
    else{
        s=S_XMax*S_YMax*(id*6+level)+y*S_XMax+x;
    }
 	return *(pS+s);

}

//存S的值
int JY_SetS(int id,int x,int y,int level,int v)
{
    FILE *fp;
    int s;
    short value=(short)v;
    if(id<0 || id>=S_Num){
        fprintf(stderr,"SetS error: sceneid=%d out of range!\n",id);
        return 0;
    }
    if(g_LoadFullS==0){ 
        if(id==currentS){
            s=S_XMax*S_YMax*level+y*S_XMax+x;
	        *(pS+s)=value;
        }
        else{
	        if((fp=fopen(TempS_filename,"r+b"))==NULL){
                fprintf(stderr,"JY_LoadSMap error:file not open ---%s",TempS_filename);
		        return 0;
	        }
            fseek(fp,(S_XMax*S_YMax*(id*6+level)+y*S_XMax+x)*2,SEEK_SET);
            fwrite(&value,2,1,fp);
 	        fclose(fp);
        }
    }
    else{
        s=S_XMax*S_YMax*(id*6+level)+y*S_XMax+x;
        *(pS+s)=value;
    }
  
	return 0;

}

//取D*
int JY_GetD(int Sceneid,int id,int i)
{
    int s;
    if(Sceneid<0 || Sceneid>=S_Num){
        fprintf(stderr,"GetD error: sceneid=%d out of range!\n",Sceneid);
        return 0;
    }

    s=D_Num1*D_Num2*Sceneid+id*D_Num2+i;

	return *(pD+s);
}

//存D*
int JY_SetD(int Sceneid,int id,int i,int v)
{
    int s;
    if(Sceneid<0 || Sceneid>=S_Num){
        fprintf(stderr,"GetD error: sceneid=%d out of range!\n",Sceneid);
        return 0;
    }

    s=D_Num1*D_Num2*Sceneid+id*D_Num2+i;

	*(pD+s)=(short)v;

	return 0;
}


// 绘制场景地图
int JY_DrawSMap(int sceneid,int x, int y,int xoff,int yoff, int Mypic)
{

    int rangex=g_ScreenW/(2*g_XScale)/2+1+g_SMapAddX;
	int rangey=g_ScreenH/(2*g_YScale)/2+1;
	int i,j;
	int i1,j1;
	int x1,y1;
 
	int xx,yy;

	JY_FillColor(0,0,0,0,0);

	for(j=0;j<=2*2*rangey+g_SMapAddY;j++){
	    for(i=-rangex;i<=rangex;i++){
			if(j%2==0){
                i1=i+j/2-rangey;
				j1=-i+j/2-rangey;
			}
			else{
                i1=i+j/2-rangey;
				j1=-i+j/2+1-rangey;
			}
    
            x1=g_XScale*(i1-j1)+g_ScreenW/2;
			y1=g_YScale*(i1+j1)+g_ScreenH/2;

			xx=x+i1+xoff;
			yy=y+j1+yoff;

			if( (xx>=0) && (xx<S_XMax) && (yy>=0) && (yy<S_YMax) ){
                int d0=JY_GetS(sceneid,xx,yy,0);
                if(d0>0)
                      JY_LoadPic(0,d0,x1,y1,0,0);             //地面
			}
		}
	}

	for(j=0;j<=2*2*rangey+g_SMapAddY;j++){
	    for(i=-rangex;i<=rangex;i++){
			if(j%2==0){
                i1=i+j/2-rangey;
				j1=-i+j/2-rangey;
			}
			else{
                i1=i+j/2-rangey;
				j1=-i+j/2+1-rangey;
			}
           
            x1=g_XScale*(i1-j1)+g_ScreenW/2;
			y1=g_YScale*(i1+j1)+g_ScreenH/2;

			xx=x+i1+xoff;
			yy=y+j1+yoff;

			if( (xx>=0) && (xx<S_XMax) && (yy>=0) && (yy<S_YMax) ){
                int d1=JY_GetS(sceneid,xx,yy,1);
                int d2=JY_GetS(sceneid,xx,yy,2);
                int d3=JY_GetS(sceneid,xx,yy,3);
                int d4=JY_GetS(sceneid,xx,yy,4);
                int d5=JY_GetS(sceneid,xx,yy,5);
      
                if(d1>0)
                      JY_LoadPic(0,d1,x1,y1-d4,0,0);           //建筑
			
                if(d2>0)
                      JY_LoadPic(0,d2,x1,y1-d5,0,0);          //空中

				if(d3>=0){           // 事件
					int picnum=JY_GetD(sceneid,d3,7);
					if(picnum>=0)
                       JY_LoadPic(0,picnum,x1,y1-d4,0,0);
				}

				if( (i1==-xoff) && (j1==-yoff) ){  //主角
                       JY_LoadPic(0,Mypic*2,x1,y1-d4,0,0);
				}
			}
		}
	}

     return 0;
}

//加载战斗地图
// WarIDXfilename/WarGRPfilename 战斗地图idx/grp文件名
// mapid 战斗地图编号
// num 战斗地图数据层数   应为6
//         0层 地面数据
//         1层 建筑
//         2层 战斗人战斗编号
//         3层 移动时显示可移动的位置
//               显示数字是保存命中数字              
//         4层 命中效果
//         5层 战斗人对应的贴图
// x_max,x_max   地图大小
int JY_LoadWarMap(const char *WarIDXfilename,const char *WarGRPfilename, int mapid,int num, int x_max,int y_max)
{
    FILE *fp;
	int p;

    War_XMax=x_max;
	War_YMax=y_max;
	War_Num=num;

    JY_UnloadWarMap();

    if(pWar==NULL)
	    pWar=(Uint16*) malloc(x_max*y_max*num*2);

	if(pWar==NULL){
		fprintf(stderr,"JY_LoadWarMap error: can not malloc memory\n");
		return 0;
	}

	if(mapid==0){        //第0个地图，从0开始读
		p=0;
	}
	else{
		if((fp=fopen(WarIDXfilename,"rb"))==NULL){      //读idx文件
            fprintf(stderr,"file not open ---%s",WarIDXfilename);
		    return 0;
		}
        fseek(fp,4*(mapid-1),SEEK_SET);
        fread(&p,4,1,fp);
	    fclose(fp);
	};


	if((fp=fopen(WarGRPfilename,"rb"))==NULL){
        fprintf(stderr,"file not open ---%s",WarIDXfilename);
		return 0;
	}
    fseek(fp,p,SEEK_SET);
    fread(pWar,2,x_max*y_max*2,fp);
	fclose(fp);

	return 0;

}

int JY_UnloadWarMap()
{
    
    SafeFree(pWar);
 
    return 0;
}

//取战斗地图数据
int JY_GetWarMap(int x,int y,int level)
{
    int s=War_XMax*War_YMax*level+y*War_XMax+x;

	return *(pWar+s);

}

//存战斗地图数据
int JY_SetWarMap(int x,int y,int level,int v)
{
    int s=War_XMax*War_YMax*level+y*War_XMax+x;

	*(pWar+s)=(short)v;

	return 0;

}

//设置某层战斗地图为给定值
int JY_CleanWarMap(int level,int v)
{
    short *p=pWar+War_XMax*War_YMax*level;
    int i;
    for(i=0;i<War_XMax*War_YMax;i++){
        *p=(short)v;
        p++;
    }
    return 0;  
} 

// 绘制战斗地图
// flag=0  绘制基本战斗地图
//     =1  显示可移动的路径，(v1,v2)当前移动坐标，白色背景(雪地战斗)
//     =2  显示可移动的路径，(v1,v2)当前移动坐标，黑色背景
//     =3  命中的人物用白色轮廓显示
//     =4  战斗动作动画  v1 战斗人物pic, v2贴图类型 0 常规贴图文件 4 fight***.idx/grp
//     =5  武功效果 v1 武功效果pic

int JY_DrawWarMap(int flag, int x, int y, int v1,int v2)
{

    int rangex=g_ScreenW/(2*g_XScale)/2+1+g_WMapAddX;
	int rangey=g_ScreenH/(2*g_YScale)/2+1 ;
	int i,j;
	int i1,j1;
	int x1,y1;
 
 
	int xx,yy;

	JY_FillColor(0,0,0,0,0);

    // 绘战斗地面
	for(j=0;j<=2*2*rangey+g_WMapAddY;j++){
	    for(i=-rangex;i<=rangex;i++){
			if(j%2==0){
                i1=i+j/2-rangey;
				j1=-i+j/2-rangey;
			}
			else{
                i1=i+j/2-rangey;
				j1=-i+j/2+1-rangey;
			}
    
            x1=g_XScale*(i1-j1)+g_ScreenW/2;
			y1=g_YScale*(i1+j1)+g_ScreenH/2;
			xx=x+i1 ;
			yy=y+j1 ;
			if( (xx>=0) && (xx<War_XMax) && (yy>=0) && (yy<War_YMax) ){
                int num=JY_GetWarMap(xx,yy,0);            
                if(num>0)
 					JY_LoadPic(0,num,x1,y1,0,0);     //地面
			}
		}
	}

if( (flag==1) || (flag==2) ){     //在地面上绘制移动范围
	for(j=0;j<=2*2*rangey+g_WMapAddY;j++){
	    for(i=-rangex;i<=rangex;i++){
			if(j%2==0){
                i1=i+j/2-rangey;
				j1=-i+j/2-rangey;
			}
			else{
                i1=i+j/2-rangey;
				j1=-i+j/2+1-rangey;
			}
    
            x1=g_XScale*(i1-j1)+g_ScreenW/2;
			y1=g_YScale*(i1+j1)+g_ScreenH/2;
			xx=x+i1 ;
			yy=y+j1 ;
			if( (xx>=0) && (xx<War_XMax) && (yy>=0) && (yy<War_YMax) ){
				if(JY_GetWarMap(xx,yy,3)<128){
					int showflag;
					if(flag==1)
						showflag=2+4;
					else
						showflag=2+8;

					if((xx==v1)&&(yy==v2))
 
                        JY_LoadPic(0,0,x1,y1,showflag,128);    
					else
   					    JY_LoadPic(0,0,x1,y1,showflag,64);

                }

			}
		}
	}
}

    // 绘战斗建筑和人
	for(j=0;j<=2*2*rangey+g_WMapAddY;j++){
	    for(i=-rangex;i<=rangex;i++){
			if(j%2==0){
                i1=i+j/2-rangey;
				j1=-i+j/2-rangey;
			}
			else{
                i1=i+j/2-rangey;
				j1=-i+j/2+1-rangey;
			}
    
            x1=g_XScale*(i1-j1)+g_ScreenW/2;
			y1=g_YScale*(i1+j1)+g_ScreenH/2;
			xx=x+i1 ;
			yy=y+j1 ;
			if( (xx>=0) && (xx<War_XMax) && (yy>=0) && (yy<War_YMax) ){
                int num=JY_GetWarMap(xx,yy,1);    //  建筑      
                if(num>0)
                	JY_LoadPic(0,num,x1,y1,0,0);

				num=JY_GetWarMap(xx,yy,2);        // 战斗人
				if(num>=0){
                    int pic=JY_GetWarMap(xx,yy,5);  // 人贴图
					if(pic>=0){
						switch(flag){
						case 0:
						case 1:
						case 2:  
                        case 5: //人物常规显示
							JY_LoadPic(0,pic,x1,y1,0,0);
							break;
						case 3:
							if(JY_GetWarMap(xx,yy,4)>1)   //命中
  							    JY_LoadPic(0,pic,x1,y1,4+2,255);  //变黑
							else
							    JY_LoadPic(0,pic,x1,y1,0,0);

							break;
						case 4:
							if( (xx==x) && (yy==y) ){
                                if(v2==0)
								    JY_LoadPic(0,pic,x1,y1,0,0);
                                else
 							        JY_LoadPic(v2,v1,x1,y1,0,0);
                            }
							else{
								 JY_LoadPic(0,pic,x1,y1,0,0);
							}

							break;
						}
					}
				}
                
                if(flag==5){   //武功效果
	                 int effect=JY_GetWarMap(xx,yy,4);
				    if(effect>0){
                         JY_LoadPic(3,v1,x1,y1,0,0);
				    }
                }


			}
		}
	}


     return 0;
}

//绘命中点数
int JY_DrawWarNum(int x, int y, int height,int color,int size,const char *fontname, 
			   int charset, int OScharset)
{

    int rangex=g_ScreenW/(2*g_XScale)/2+1+g_WMapAddY;
	int rangey=g_ScreenH/(2*g_YScale)/2+1;
	int i,j;
	int i1,j1;
	int x1,y1;
	char tmpstr[255];
 
	int xx,yy;

	JY_DrawWarMap(0,x,y,0,0);

    // 绘战斗地面
	for(j=0;j<=2*2*rangey+g_WMapAddY;j++){
	    for(i=-rangex;i<=rangex;i++){
			if(j%2==0){
                i1=i+j/2-rangey;
				j1=-i+j/2-rangey;
			}
			else{
                i1=i+j/2-rangey;
				j1=-i+j/2+1-rangey;
			}
    
            x1=g_XScale*(i1-j1)+g_ScreenW/2;
			y1=g_YScale*(i1+j1)+g_ScreenH/2;
			xx=x+i1 ;
			yy=y+j1 ;
			if( (xx>=0) && (xx<War_XMax) && (yy>=0) && (yy<War_YMax) ){
				int num=JY_GetWarMap(xx,yy,2);        // 战斗人
				if(num>=0){
                    int effect=JY_GetWarMap(xx,yy,4);
					if(effect>1){
						int newr=((color & 0xff0000)>>16)/2;
						int newg=((color & 0xff00)>>8)/2;
						int newb=((color & 0xff))/2;
						int newcolor=(newr<<16) + (newg<<8) +newb;
						int nn=JY_GetWarMap(xx,yy,3);
						sprintf(tmpstr,"%+d",nn);
						JY_DrawStr(x1+1,y1-65-height+1,tmpstr,newcolor,size,fontname,charset,OScharset);
						JY_DrawStr(x1,y1-65-height,tmpstr,color,size,fontname,charset,OScharset);
					}
				}
                
			}
		}
	}

	return 0;
}


