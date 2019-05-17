
//��������ͼ��������ͼ��ս����ͼ
//Ϊ�ӿ��ٶȣ���Щ������Ϊc��ʵ��

 
#include "jymain.h"

 
//����ͼ����
static short *pEarth=NULL;
static short *pSurface=NULL;
static short *pBuilding=NULL;
static short *pBuildX=NULL;
static short *pBuildY=NULL;

static int XMax,YMax;  //����ͼ��С
 
static int BuildNumber;     //ʵ���������

static BuildingType Build[2000];        // ������������
  
static int S_XMax,S_YMax;      // ������ͼ��С
static int S_Num;
static Sint16 *pS=NULL;              // ����S*����

// Ϊ�����ڴ�ռ�ã���S�ļ�������ʱ�ļ���ʽ���ʣ�ֻ���ڴ��б��浱ǰ������S����
static char TempS_filename[255];     //��ʱS�ļ���
static int currentS=-1;              //��ǰ���صĳ���S����

static int D_Num1;             // ÿ������D�ĸ���
static int D_Num2;             // ÿ��D�����ݸ���

static Sint16 *pD=NULL;              // ����D*����

static int War_XMax,War_YMax;      // ս����ͼ��С
static int War_Num;                // ս����ͼ����
static Sint16 *pWar=NULL;           // ս����ͼ����

 
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


// ��ȡ����ͼ����
int JY_LoadMMap(const char* earthname, const char* surfacename, const char*buildingname,
				const char* buildxname, const char* buildyname, int x_max, int y_max)
{
    FILE *fp;

    XMax=x_max;
	YMax=y_max;

    JY_UnloadMMap();
	//��ȡearth�ļ�
    pEarth=(Uint16*) malloc(XMax*YMax*2);

	if((fp=fopen(earthname,"rb"))==NULL){
        fprintf(stderr,"file not open ---%s",earthname);
		return 1;
	}
    fread(pEarth,2,XMax*YMax,fp);
	fclose(fp);

	//��ȡsurface�ļ�
    pSurface=(Uint16*) malloc(XMax*YMax*2);

	if((fp=fopen(surfacename,"rb"))==NULL){
        fprintf(stderr,"file not open ---%s",surfacename);
		return 0;
	}
    fread(pSurface,2,XMax*YMax,fp);
	fclose(fp); 

	//��ȡbuilding�ļ�
    pBuilding=(Uint16*) malloc(XMax*YMax*2);

	if((fp=fopen(buildingname,"rb"))==NULL){
        fprintf(stderr,"file not open ---%s",buildingname);
		return 0;
	}
    fread(pBuilding,2,XMax*YMax,fp);
	fclose(fp); 

	//��ȡbuilding�ļ�
    pBuildX=(Uint16*) malloc(XMax*YMax*2);

	if((fp=fopen(buildxname,"rb"))==NULL){
        fprintf(stderr,"file not open ---%s",buildxname);
		return 0;
	}
    fread(pBuildX,2,XMax*YMax,fp);
	fclose(fp); 

	//��ȡbuilding�ļ�
    pBuildY=(Uint16*) malloc(XMax*YMax*2);

	if((fp=fopen(buildyname,"rb"))==NULL){
        fprintf(stderr,"file not open ---%s",buildyname);
		return 0;
	}
    fread(pBuildY,2,XMax*YMax,fp);
	fclose(fp); 

	return 0;
}

// �ͷ�����ͼ����
int JY_UnloadMMap(void)
{
    
    SafeFree(pEarth);
    SafeFree(pSurface);
    SafeFree(pBuilding);
    SafeFree(pBuildX);
    SafeFree(pBuildY);

    return 0;
}


// ȡ����ͼ���� 
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

// ������ͼ���� 
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


// ����ͼ�������� 
// x,y ��������
// Mypic ������ͼ���
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



// ��������ͼ
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


//��ȡS*D*
int JY_LoadSMap(const char *Sfilename,const char*tmpfilename, int num,int x_max,int y_max,
				const char *Dfilename,int d_num1,int d_num2)
{
    FILE *fp,*fp2;
    int i; 

    S_XMax=x_max;
	S_YMax=y_max;
    S_Num=num;

	//��ȡS�ļ�
    if(g_LoadFullS==0){     //��ȡs����ʱ�ļ�
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
    else{      //ȫ�������ڴ�
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
	
    //��ȡD�ļ�
  

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

//����S*D*
int JY_SaveSMap(const char *Sfilename,const char *Dfilename)
{
    FILE *fp,*fp2;
    int i; 
    
	if(pS==NULL)
		return 0;

    if(g_LoadFullS==0){    //��ȡ����Sʱ�ı���
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

//����ʱ�ļ��ж�ȡ����id��S���ݵ��ڴ�
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

//���ڴ���д�볡��id��S���ݵ���ʱ�ļ�
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

//ȡs��ֵ
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

//��S��ֵ
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

//ȡD*
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

//��D*
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


// ���Ƴ�����ͼ
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
                      JY_LoadPic(0,d0,x1,y1,0,0);             //����
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
                      JY_LoadPic(0,d1,x1,y1-d4,0,0);           //����
			
                if(d2>0)
                      JY_LoadPic(0,d2,x1,y1-d5,0,0);          //����

				if(d3>=0){           // �¼�
					int picnum=JY_GetD(sceneid,d3,7);
					if(picnum>=0)
                       JY_LoadPic(0,picnum,x1,y1-d4,0,0);
				}

				if( (i1==-xoff) && (j1==-yoff) ){  //����
                       JY_LoadPic(0,Mypic*2,x1,y1-d4,0,0);
				}
			}
		}
	}

     return 0;
}

//����ս����ͼ
// WarIDXfilename/WarGRPfilename ս����ͼidx/grp�ļ���
// mapid ս����ͼ���
// num ս����ͼ���ݲ���   ӦΪ6
//         0�� ��������
//         1�� ����
//         2�� ս����ս�����
//         3�� �ƶ�ʱ��ʾ���ƶ���λ��
//               ��ʾ�����Ǳ�����������              
//         4�� ����Ч��
//         5�� ս���˶�Ӧ����ͼ
// x_max,x_max   ��ͼ��С
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

	if(mapid==0){        //��0����ͼ����0��ʼ��
		p=0;
	}
	else{
		if((fp=fopen(WarIDXfilename,"rb"))==NULL){      //��idx�ļ�
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

//ȡս����ͼ����
int JY_GetWarMap(int x,int y,int level)
{
    int s=War_XMax*War_YMax*level+y*War_XMax+x;

	return *(pWar+s);

}

//��ս����ͼ����
int JY_SetWarMap(int x,int y,int level,int v)
{
    int s=War_XMax*War_YMax*level+y*War_XMax+x;

	*(pWar+s)=(short)v;

	return 0;

}

//����ĳ��ս����ͼΪ����ֵ
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

// ����ս����ͼ
// flag=0  ���ƻ���ս����ͼ
//     =1  ��ʾ���ƶ���·����(v1,v2)��ǰ�ƶ����꣬��ɫ����(ѩ��ս��)
//     =2  ��ʾ���ƶ���·����(v1,v2)��ǰ�ƶ����꣬��ɫ����
//     =3  ���е������ð�ɫ������ʾ
//     =4  ս����������  v1 ս������pic, v2��ͼ���� 0 ������ͼ�ļ� 4 fight***.idx/grp
//     =5  �书Ч�� v1 �书Ч��pic

int JY_DrawWarMap(int flag, int x, int y, int v1,int v2)
{

    int rangex=g_ScreenW/(2*g_XScale)/2+1+g_WMapAddX;
	int rangey=g_ScreenH/(2*g_YScale)/2+1 ;
	int i,j;
	int i1,j1;
	int x1,y1;
 
 
	int xx,yy;

	JY_FillColor(0,0,0,0,0);

    // ��ս������
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
 					JY_LoadPic(0,num,x1,y1,0,0);     //����
			}
		}
	}

if( (flag==1) || (flag==2) ){     //�ڵ����ϻ����ƶ���Χ
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

    // ��ս����������
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
                int num=JY_GetWarMap(xx,yy,1);    //  ����      
                if(num>0)
                	JY_LoadPic(0,num,x1,y1,0,0);

				num=JY_GetWarMap(xx,yy,2);        // ս����
				if(num>=0){
                    int pic=JY_GetWarMap(xx,yy,5);  // ����ͼ
					if(pic>=0){
						switch(flag){
						case 0:
						case 1:
						case 2:  
                        case 5: //���ﳣ����ʾ
							JY_LoadPic(0,pic,x1,y1,0,0);
							break;
						case 3:
							if(JY_GetWarMap(xx,yy,4)>1)   //����
  							    JY_LoadPic(0,pic,x1,y1,4+2,255);  //���
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
                
                if(flag==5){   //�书Ч��
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

//�����е���
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

    // ��ս������
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
				int num=JY_GetWarMap(xx,yy,2);        // ս����
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


