
----------------------------------------------------------
-----------��ӹȺ��������֮Lua��----------------------------

--��Ȩ���ޣ����븴��
--����������ʹ�ô���

---����������Ӿ�����д

--��ģ����lua��ģ�飬��C������JYLua.exe���á�C������Ҫ�ṩ��Ϸ��Ҫ����Ƶ�����֡����̵�API��������lua���á�
--��Ϸ�������߼�����lua�����У��Է����ҶԴ�����޸ġ�
--Ϊ�ӿ��ٶȣ���ʾ����ͼ/������ͼ/ս����ͼ������C APIʵ�֡�

--��������ģ�顣֮�������ɺ�����Ϊ�˱��������ʱ��������Ѱ����Щģ�顣
function IncludeFile()              --��������ģ��
    --dofile("config.lua");       --���ļ���C������Ԥ�ȼ��ء�����Ͳ�������
    dofile(CONFIG.ScriptPath .. "jyconst.lua");
    dofile(CONFIG.ScriptPath .. "jymodify.lua");
end


function SetGlobal()   --������Ϸ�ڲ�ʹ�õ�ȫ�̱���
   JY={};

   JY.Status=GAME_INIT;  --��Ϸ��ǰ״̬

   --����R������
   JY.Base={};           --��������
   JY.PersonNum=0;      --�������
   JY.Person={};        --��������
   JY.ThingNum=0        --��Ʒ����
   JY.Thing={};         --��Ʒ����
   JY.SceneNum=0        --��Ʒ����
   JY.Scene={};         --��Ʒ����
   JY.WugongNum=0        --��Ʒ����
   JY.Wugong={};         --��Ʒ����
   JY.ShopNum=0        --�̵�����
   JY.Shop={};         --�̵�����

   JY.Data_Base=nil;     --ʵ�ʱ���R*����
   JY.Data_Person=nil;
   JY.Data_Thing=nil;
   JY.Data_Scene=nil;
   JY.Data_Wugong=nil;
   JY.Data_Shop=nil;

   JY.MyCurrentPic=0;       --���ǵ�ǰ��·��ͼ����ͼ�ļ���ƫ��
   JY.MyPic=0;              --���ǵ�ǰ��ͼ
   JY.MyTick=0;             --����û����·�ĳ���֡��
   JY.MyTick2=0;            --��ʾ�¼������Ľ���

   JY.EnterSceneXY=nil;     --������볡�������꣬��ֵ���Խ��룬Ϊnil�����¼��㡣

   JY.oldMMapX=-1;          --�ϴ���ʾ����ͼ�����ꡣ�����ж��Ƿ���Ҫȫ���ػ���Ļ
   JY.oldMMapY=-1;
   JY.oldMMapPic=-1;        --�ϴ���ʾ����ͼ������ͼ

   JY.SubScene=-1;          --��ǰ�ӳ������
   JY.SubSceneX=0;          --�ӳ�����ʾλ��ƫ�ƣ������ƶ�ָ��ʹ��
   JY.SubSceneY=0;

   JY.Darkness=0;             --=0 ��Ļ������ʾ��=1 ����ʾ����Ļȫ��

   JY.CurrentD=-1;          --��ǰ����D*�ı��
   JY.OldDPass=-1;          --�ϴδ���·���¼���D*���, �����δ���
   JY.CurrentEventType=-1   --��ǰ�����¼��ķ�ʽ 1 �ո� 2 ��Ʒ 3 ·��

   JY.oldSMapX=-1;          --�ϴ���ʾ������ͼ�����ꡣ�����ж��Ƿ���Ҫȫ���ػ���Ļ
   JY.oldSMapY=-1;
   JY.oldSMapXoff=-1;       --�ϴγ���ƫ��
   JY.oldSMapYoff=-1;
   JY.oldSMapPic=-1;        --�ϴ���ʾ������ͼ������ͼ

   JY.D_Valid=nil           --��¼��ǰ������Ч��D�ı�ţ�����ٶȣ�����ÿ����ʾ�������ˡ���Ϊnil�����¼���
   JY_D_Valld_Num=0;        --��ǰ������Ч��D����

   JY.D_PicChange={}        --��¼�¼������ı䣬�Լ���Clip
   JY.NumD_PicChange=0;     --�¼������ı�ĸ���

   JY.CurrentThing=-1;      --��ǰѡ����Ʒ�������¼�ʹ��

   JY.MmapMusic=-1;         --�л����ͼ���֣���������ͼʱ��������ã��򲥷Ŵ�����

   JY.CurrentMIDI=-1;       --��ǰ���ŵ�����id�������ڹر�����ʱ��������id��
   JY.EnableMusic=1;        --�Ƿ񲥷����� 1 ���ţ�0 ������
   JY.EnableSound=1;        --�Ƿ񲥷���Ч 1 ���ţ�0 ������

   JY.ThingUseFunction={};          --��Ʒʹ��ʱ���ú�����SetModify����ʹ�ã����������͵���Ʒ
   JY.SceneNewEventFunction={};     --���ó����¼�������SetModify����ʹ�ã�����ʹ���³����¼������ĺ���

   WAR={};     --ս��ʹ�õ�ȫ�̱�����������ռ��λ�ã���Ϊ������治������ȫ�ֱ����ˡ�����������WarSetGlobal������
end

function JY_Main()        --���������
	os.remove("debug.txt");        --�����ǰ��debug���
    xpcall(JY_Main_sub,myErrFun);     --������ô���
end

function myErrFun(err)      --��������ӡ������Ϣ
    lib.Debug(err);                 --���������Ϣ
    lib.Debug(debug.traceback());   --������ö�ջ��Ϣ
end

function JY_Main_sub()        --��������Ϸ���������
    IncludeFile();         --��������ģ��
    SetGlobalConst();    --����ȫ�̱���CC, ����ʹ�õĳ���
    SetGlobal();         --����ȫ�̱���JY

    GenTalkIdx();        --���ɶԻ�idx

    SetModify();         --���öԺ������޸ģ������µ���Ʒ���¼��ȵ�

    --��ֹ����ȫ�̱���
    setmetatable(_G,{ __newindex =function (_,n)
                       error("attempt read write to undeclared variable " .. n,2);
                       end,
                       __index =function (_,n)
                       error("attempt read read to undeclared variable " .. n,2);
                       end,
                     }  );
    lib.Debug("JY_Main start.");

	math.randomseed(os.time());          --��ʼ�������������

	lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRePeatInterval);   --���ü����ظ���

    JY.Status=GAME_START;

    lib.PicInit(CC.PaletteFile);       --����ԭ����256ɫ��ɫ��

    lib.PlayMPEG(CONFIG.DataPath .. "start.mpg",VK_ESCAPE);

	Cls();

    PlayMIDI(16);
	lib.ShowSlow(50,0);

	local menu={  {"���¿�ʼ",nil,1},
	              {"�������",nil,1},
	              {"�뿪��Ϸ",nil,1}  };
	local menux=(CC.ScreenW-4*CC.StartMenuFontSize-2*CC.MenuBorderPixel)/2

	local menuReturn=ShowMenu(menu,3,0,menux,CC.StartMenuY,0,0,0,0,CC.StartMenuFontSize,C_STARTMENU, C_RED)

    if menuReturn == 1 then        --���¿�ʼ��Ϸ
		Cls();
		DrawString(menux,CC.StartMenuY,"���Ժ�...",C_RED,CC.StartMenuFontSize);
		ShowScreen();

		NewGame();          --��������Ϸ����

        JY.SubScene=CC.NewGameSceneID;         --����Ϸֱ�ӽ��볡��
        JY.Scene[JY.SubScene]["����"]=JY.Person[0]["����"] .. "��";
        JY.Base["��X1"]=CC.NewGameSceneX;
        JY.Base["��Y1"]=CC.NewGameSceneY;
        JY.MyPic=CC.NewPersonPic;

        lib.ShowSlow(50,1)
		JY.Status=GAME_SMAP;
        JY.MMAPMusic=-1;

 	    CleanMemory();

		Init_SMap(0);

        if CC.NewGameEvent>0 then
		   oldCallEvent(CC.NewGameEvent);
	    end

	elseif menuReturn == 2 then         --����ɵĽ���
		Cls();
    	local loadMenu={ {"����һ",nil,1},
	                     {"���ȶ�",nil,1},
	                     {"������",nil,1} };

	    local menux=(CC.ScreenW-3*CC.StartMenuFontSize-2*CC.MenuBorderPixel)/2

    	local r=ShowMenu(loadMenu,3,0,menux,CC.StartMenuY,0,0,0,0,CC.StartMenuFontSize,C_STARTMENU, C_RED)
		Cls();
		DrawString(menux,CC.StartMenuY,"���Ժ�...",C_RED,CC.StartMenuFontSize);
		ShowScreen();
        LoadRecord(r);
		Cls();
		ShowScreen();
		JY.Status=GAME_FIRSTMMAP;

	elseif menuReturn == 3 then
        return ;
	end
	lib.LoadPicture("",0,0);
    lib.GetKey();
    Game_Cycle();
end

function CleanMemory()            --����lua�ڴ�
    if CONFIG.CleanMemory==1 then
		 collectgarbage("collect");
		 --lib.Debug(string.format("Lua memory=%d",collectgarbage("count")));
    end
end

function NewGame()     --ѡ������Ϸ���������ǳ�ʼ����
    LoadRecord(0); --  ��������Ϸ����
    JY.Person[0]["����"]=CC.NewPersonName;

    while true do
        JY.Person[0]["��������"]=Rnd(2);
        JY.Person[0]["�������ֵ"]=Rnd(20)+21;
        JY.Person[0]["������"]=Rnd(10)+21;
        JY.Person[0]["������"]=Rnd(10)+21;
        JY.Person[0]["�Ṧ"]=Rnd(10)+21;
        JY.Person[0]["ҽ������"]=Rnd(10)+21;
        JY.Person[0]["�ö�����"]=Rnd(10)+21;
        JY.Person[0]["�ⶾ����"]=Rnd(10)+21;
        JY.Person[0]["��������"]=Rnd(10)+21;
        JY.Person[0]["ȭ�ƹ���"]=Rnd(10)+21;
        JY.Person[0]["��������"]=Rnd(10)+21;
        JY.Person[0]["ˣ������"]=Rnd(10)+21;
        JY.Person[0]["�������"]=Rnd(10)+21;
        JY.Person[0]["��������"]=Rnd(10)+21;
        JY.Person[0]["��������"]=Rnd(5)+3;
        JY.Person[0]["�������ֵ"]= JY.Person[0]["��������"]*3+29;

        local rate=Rnd(10);
        if rate<2 then
            JY.Person[0]["����"]=Rnd(35)+30;
        elseif rate<=7 then
            JY.Person[0]["����"]=Rnd(20)+60;
        else
            JY.Person[0]["����"]=Rnd(20)+75;
        end

        JY.Person[0]["����"]=JY.Person[0]["�������ֵ"];
        JY.Person[0]["����"]=JY.Person[0]["�������ֵ"];

        Cls();

        local fontsize=CC.NewGameFontSize;

        local h=fontsize+CC.RowPixel;
        local w=fontsize*4;
		local x1=(CC.ScreenW-w*4)/2;
        local y1=CC.NewGameY;
        local i=0;

        local function DrawAttrib(str1,str2)    --�����ڲ�����
            DrawString(x1+i*w,y1,str1,C_RED,fontsize);
            DrawString(x1+i*w+fontsize*2,y1,string.format("%3d ",JY.Person[0][str2]),C_WHITE,fontsize);
            i=i+1;
        end

        DrawString(x1,y1,"����������������(Y/N)?",C_GOLD,fontsize);
        i=0; y1=y1+h;
		DrawAttrib("����","����"); DrawAttrib("����","������"); DrawAttrib("�Ṧ","�Ṧ");  DrawAttrib("����","������");
        i=0; y1=y1+h;
		DrawAttrib("����","����"); DrawAttrib("ҽ��","ҽ������");DrawAttrib("�ö�","�ö�����"); DrawAttrib("�ⶾ","�ⶾ����");
        i=0; y1=y1+h;
        DrawAttrib("ȭ��","ȭ�ƹ���"); DrawAttrib("����","��������");  DrawAttrib("ˣ��","ˣ������"); DrawAttrib("����","��������");

        ShowScreen();

		local menu={{"�� ",nil,1},
		            {"�� ",nil,2},
			       };
        local ok=ShowMenu2(menu,2,0,x1+11*fontsize,CC.NewGameY-CC.MenuBorderPixel,0,0,0,0,fontsize,C_RED, C_WHITE)
        if ok==1 then
            break;
        end
    end
end


function Game_Cycle()       --��Ϸ��ѭ��
    lib.Debug("Start game cycle");

    while JY.Status ~=GAME_END do
        local tstart=lib.GetTime();

	    JY.MyTick=JY.MyTick+1;    --20�������޻����������Ǳ�Ϊվ��״̬
	    JY.MyTick2=JY.MyTick2+1;    --20�������޻����������Ǳ�Ϊվ��״̬

		if JY.MyTick==20 then
            JY.MyCurrentPic=0;
			JY.MyTick=0;
		end

        if JY.MyTick2==1000 then
            JY.MYtick2=0;
        end

        if JY.Status==GAME_FIRSTMMAP then  --�״���ʾ�����������µ�����������ͼ��������ʾ��Ȼ��ת��������ʾ
			CleanMemory();
            lib.ShowSlow(50,1)
            JY.MmapMusic=16;
            JY.Status=GAME_MMAP;

            Init_MMap();

            lib.DrawMMap(JY.Base["��X"],JY.Base["��Y"],GetMyPic());
			lib.ShowSlow(50,0);
        elseif JY.Status==GAME_MMAP then
            Game_MMap();
 		elseif JY.Status==GAME_SMAP then
            Game_SMap()
		end

		collectgarbage("step",0);

		local tend=lib.GetTime();

		if tend-tstart<CC.Frame then
            lib.Delay(CC.Frame-(tend-tstart));
	    end
	end
end


function Init_MMap()   --��ʼ������ͼ����
	lib.PicInit();
	lib.LoadMMap(CC.MMapFile[1],CC.MMapFile[2],CC.MMapFile[3],
			CC.MMapFile[4],CC.MMapFile[5],CC.MWidth,CC.MHeight,JY.Base["��X"],JY.Base["��Y"]);

	lib.PicLoadFile(CC.MMAPPicFile[1],CC.MMAPPicFile[2],0);
	lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],1);
	if CC.LoadThingPic==1 then
	    lib.PicLoadFile(CC.ThingPicFile[1],CC.ThingPicFile[2],2);
	end

	JY.EnterSceneXY=nil;         --��Ϊ�գ�ǿ���������ɳ���������ݡ���ֹ���¼������˳�����ڡ�
	JY.oldMMapX=-1;
	JY.oldMMapY=-1;

    PlayMIDI(JY.MmapMusic);
end


function Game_MMap()      --����ͼ

    local direct = -1;
    local keypress = lib.GetKey();
    --lib.Debug(string.format("keypress %d", keypress));
    if keypress ~= -1 then
	    JY.MyTick=0;
		if keypress==VK_ESCAPE then
			MMenu();
			if JY.Status==GAME_FIRSTMMAP then
				return ;
			end
			JY.oldMMapX=-1;         --ǿ���ػ�
			JY.oldMMapY=-1;
		elseif keypress==VK_UP then
			direct=0;
		elseif keypress==VK_DOWN then
			direct=3;
		elseif keypress==VK_LEFT then
			direct=2;
		elseif keypress==VK_RIGHT then
			direct=1;
		end
    end

    local x,y;              --���շ����Ҫ���������
    if direct ~= -1 then   --�����˹���
        AddMyCurrentPic();         --����������ͼ��ţ�������·Ч��
        x=JY.Base["��X"]+CC.DirectX[direct+1];
        y=JY.Base["��Y"]+CC.DirectY[direct+1];
        JY.Base["�˷���"]=direct;
    else
        x=JY.Base["��X"];
        y=JY.Base["��Y"];
    end

	JY.SubScene=CanEnterScene(x,y);   --�ж��Ƿ�����ӳ���

    if lib.GetMMap(x,y,3)==0 and lib.GetMMap(x,y,4)==0 then     --û�н��������Ե���
        JY.Base["��X"]=x;
        JY.Base["��Y"]=y;
    end
    JY.Base["��X"]=limitX(JY.Base["��X"],10,CC.MWidth-10);           --�������겻�ܳ�����Χ
    JY.Base["��Y"]=limitX(JY.Base["��Y"],10,CC.MHeight-10);

    if CC.MMapBoat[lib.GetMMap(JY.Base["��X"],JY.Base["��Y"],0)]==1 then
	    JY.Base["�˴�"]=1;
	else
	    JY.Base["�˴�"]=0;
	end

	local pic=GetMyPic();

    if CONFIG.FastShowScreen==1 then  --���ÿ�����ʾ����������λ�ò��䣬����ʾ�ü�����
        if JY.oldMMapX==JY.Base["��X"] and JY.oldMMapY==JY.Base["��Y"] then
			if JY.oldMMapPic>=0 and JY.oldMMapPic ~= pic then        --������ͼ�б仯����ˢ����ʾ��
				local rr=ClipRect(Cal_PicClip(0,0,JY.oldMMapPic,0,0,0,pic,0));
				if rr~=nil then
					lib.SetClip(rr.x1,rr.y1,rr.x2,rr.y2);
					lib.DrawMMap(JY.Base["��X"],JY.Base["��Y"],pic);             --��ʾ����ͼ
				end
			end
		else
			lib.SetClip(0,0,CC.ScreenW,CC.ScreenH);
			lib.DrawMMap(JY.Base["��X"],JY.Base["��Y"],pic);             --��ʾ����ͼ
		end
	else  --ȫ����ʾ
		lib.DrawMMap(JY.Base["��X"],JY.Base["��Y"],pic);             --��ʾ����ͼ
	end

	if CC.ShowXY==1 then
		DrawString(10,CC.ScreenH-20,string.format("%d %d",JY.Base["��X"],JY.Base["��Y"]) ,C_GOLD,16);
	end

	ShowScreen(CONFIG.FastShowScreen);
	lib.SetClip(0,0,0,0);

	JY.oldMMapX=JY.Base["��X"];
	JY.oldMMapY=JY.Base["��Y"];
	JY.oldMMapPic=pic;

    if JY.SubScene >= 0 then          --�����ӳ���
        CleanMemory();
		lib.UnloadMMap();
        lib.PicInit();
        lib.ShowSlow(50,1)

		JY.Status=GAME_SMAP;
        JY.MMAPMusic=-1;

        JY.MyPic=GetMyPic();
        JY.Base["��X1"]=JY.Scene[JY.SubScene]["���X"]
        JY.Base["��Y1"]=JY.Scene[JY.SubScene]["���Y"]

        Init_SMap(1);
    end

end

--showname  =1 ��ʾ������ 0 ����ʾ
function Init_SMap(showname)   --��ʼ����������
	lib.PicInit();
	lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],0);
	lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],1);
	if CC.LoadThingPic==1 then
	    lib.PicLoadFile(CC.ThingPicFile[1],CC.ThingPicFile[2],2);
	end

	PlayMIDI(JY.Scene[JY.SubScene]["��������"]);

	JY.oldSMapX=-1;
	JY.oldSMapY=-1;

	JY.SubSceneX=0;
	JY.SubSceneY=0;
	JY.OldDPass=-1;

    JY.D_Valid=nil;

	DrawSMap();
	lib.ShowSlow(50,0)
	lib.GetKey();

	if showname==1 then
		DrawStrBox(-1,10,JY.Scene[JY.SubScene]["����"],C_WHITE,CC.DefaultFont);
		ShowScreen();
		WaitKey();
		Cls();
		ShowScreen();
    end

end

--������ͼ�ı��γɵ�Clip�ü�
--(dx1,dy1) ����ͼ�ͻ�ͼ���ĵ������ƫ�ơ��ڳ����У��ӽǲ�ͬ�����Ƕ�ʱ�õ�
--pic1 �ɵ���ͼ���
--id1 ��ͼ�ļ����ر��
--(dx2,dy2) ����ͼ�ͻ�ͼ���ĵ��ƫ��
--pic2 �ɵ���ͼ���
--id2 ��ͼ�ļ����ر��
--���أ��ü����� {x1,y1,x2,y2}
function Cal_PicClip(dx1,dy1,pic1,id1,dx2,dy2,pic2,id2)   --������ͼ�ı��γɵ�Clip�ü�

	local w1,h1,x1_off,y1_off=lib.PicGetXY(id1,pic1*2);
	local old_r={};
	old_r.x1=CC.XScale*(dx1-dy1)+CC.ScreenW/2-x1_off;
    old_r.y1=CC.YScale*(dx1+dy1)+CC.ScreenH/2-y1_off;
    old_r.x2=old_r.x1+w1;
	old_r.y2=old_r.y1+h1;

	local w2,h2,x2_off,y2_off=lib.PicGetXY(id2,pic2*2);
	local new_r={};
	new_r.x1=CC.XScale*(dx2-dy2)+CC.ScreenW/2-x2_off;
    new_r.y1=CC.YScale*(dx2+dy2)+CC.ScreenH/2-y2_off;
    new_r.x2=new_r.x1+w2;
	new_r.y2=new_r.y1+h2;

	return MergeRect(old_r,new_r);
end

function MergeRect(r1,r2)     --�ϲ�����
	local res={};
	res.x1=math.min(r1.x1, r2.x1);
	res.y1=math.min(r1.y1, r2.y1);
	res.x2=math.max(r1.x2, r2.x2);
	res.y2=math.max(r1.y2, r2.y2);
	return res;
end

----�Ծ��ν�����Ļ����
--���ؼ��ú�ľ��Σ����������Ļ�����ؿ�
function ClipRect(r)    --�Ծ��ν�����Ļ����
	if r.x1>=CC.ScreenW or r.x2<= 0 or r.y1>=CC.ScreenH or r.y2 <=0 then
	    return nil
	else
	    local res={};
        res.x1=limitX(r.x1,0,CC.ScreenW);
        res.x2=limitX(r.x2,0,CC.ScreenW);
        res.y1=limitX(r.y1,0,CC.ScreenH);
        res.y2=limitX(r.y2,0,CC.ScreenH);
        return res;
	end
end

function GetMyPic()      --�������ǵ�ǰ��ͼ
    local n;
	if JY.Status==GAME_MMAP and JY.Base["�˴�"]==1 then
		if JY.MyCurrentPic >=4 then
			JY.MyCurrentPic=0
		end
	else
		if JY.MyCurrentPic >6 then
			JY.MyCurrentPic=1
		end
	end

	if JY.Base["�˴�"]==0 then
        n=CC.MyStartPic+JY.Base["�˷���"]*7+JY.MyCurrentPic;
	else
	    n=CC.BoatStartPic+JY.Base["�˷���"]*4+JY.MyCurrentPic;
	end
	return n;
end

--���ӵ�ǰ������·����֡, ����ͼ�ͳ�����ͼ��ʹ��
function AddMyCurrentPic()        ---���ӵ�ǰ������·����֡,
    JY.MyCurrentPic=JY.MyCurrentPic+1;
end

--�����Ƿ�ɽ�
--id ��������
--x,y ��ǰ����ͼ����
--���أ�����id��-1��ʾû�г����ɽ�
function CanEnterScene(x,y)         --�����Ƿ�ɽ�
    if JY.EnterSceneXY==nil then    --���Ϊ�գ������²������ݡ�
	    Cal_EnterSceneXY();
	end

    local id=JY.EnterSceneXY[y*CC.MWidth+x];
    if id~=nil then
        local e=JY.Scene[id]["��������"];
		if e==0 then        --�ɽ�
			return id;
		elseif e==1 then    --���ɽ�
			return -1
		elseif e==2 then    --���Ṧ���߽�
			for i=1,CC.TeamNum do
				local pid=JY.Base["����" .. i];
				if pid>=0 then
					if JY.Person[pid]["�Ṧ"]>=70 then
						return id;
					end
				end
			end
		end
	end
    return -1;
end

function Cal_EnterSceneXY()   --������Щ������Խ��볡��
    JY.EnterSceneXY={};
    for id = 0,JY.SceneNum-1 do
		local scene=JY.Scene[id];
        if scene["�⾰���X1"]>0 and scene["�⾰���Y1"] then
            JY.EnterSceneXY[scene["�⾰���Y1"]*CC.MWidth+scene["�⾰���X1"]]=id;
		end
        if scene["�⾰���X2"]>0 and scene["�⾰���Y2"] then
            JY.EnterSceneXY[scene["�⾰���Y2"]*CC.MWidth+scene["�⾰���X2"]]=id;
		end
    end
end

--���˵�
function MMenu()      --���˵�
    local menu={      {"ҽ��",Menu_Doctor,1},
	                  {"�ⶾ",Menu_DecPoison,1},
	                  {"��Ʒ",Menu_Thing,1},
	                  {"״̬",Menu_Status,1},
	                  {"���",Menu_PersonExit,1},
	                  {"ϵͳ",Menu_System,1},      };
    if JY.Status==GAME_SMAP then  --�ӳ������������˵����ɼ�
        menu[5][3]=0;
        menu[6][3]=0;
    end

    ShowMenu(menu,6,0,CC.MainMenuX,CC.MainMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE)
end

--ϵͳ�Ӳ˵�
function Menu_System()         --ϵͳ�Ӳ˵�
	local menu={ {"��ȡ����",Menu_ReadRecord,1},
                 {"�������",Menu_SaveRecord,1},
                 {"�뿪��Ϸ",Menu_Exit,1},   };

    local r=ShowMenu(menu,3,0,CC.MainSubMenuX,CC.MainSubMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
    if r == 0 then
        return 0;
    elseif r<0 then   --Ҫ�˳�ȫ���˵���
        return 1;
 	end
end

--�뿪�˵�
function Menu_Exit()      --�뿪�˵�
    Cls();
    if DrawStrBoxYesNo(-1,-1,"�Ƿ����Ҫ�뿪��Ϸ��",C_WHITE,CC.DefaultFont) == true then
        JY.Status =GAME_END;
    end
    return 1;
end

--�������
function Menu_SaveRecord()         --������Ȳ˵�
	local menu={ {"����һ",nil,1},
                 {"���ȶ�",nil,1},
                 {"������",nil,1},  };
    local r=ShowMenu(menu,3,0,CC.MainSubMenuX2,CC.MainSubMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
    if r>0 then
        DrawStrBox(CC.MainSubMenuX2,CC.MainSubMenuY,"���Ժ�......",C_WHITE,CC.DefaultFont);
        ShowScreen();
        SaveRecord(r);
        Cls(CC.MainSubMenuX2,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
	end
    return 0;
end

--��ȡ����
function Menu_ReadRecord()        --��ȡ���Ȳ˵�
	local menu={ {"����һ",nil,1},
                 {"���ȶ�",nil,1},
                 {"������",nil,1},  };
    local r=ShowMenu(menu,3,0,CC.MainSubMenuX2,CC.MainSubMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r == 0 then
        return 0;
    elseif r>0 then
        DrawStrBox(CC.MainSubMenuX2,CC.MainSubMenuY,"���Ժ�......",C_WHITE,CC.DefaultFont);
        ShowScreen();
        LoadRecord(r);
		JY.Status=GAME_FIRSTMMAP;
        return 1;
	end
end

--״̬�Ӳ˵�
function Menu_Status()           --״̬�Ӳ˵�
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"Ҫ����˭��״̬",C_WHITE,CC.DefaultFont);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;

    local r=SelectTeamMenu(CC.MainSubMenuX,nexty);
    if r >0 then
        ShowPersonStatus(r)
		return 1;
	else
		Cls();
        return 0;
	end
end

--���Exit
function Menu_PersonExit()        --���Exit
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"Ҫ��˭���",C_WHITE,CC.DefaultFont);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;

	local r=SelectTeamMenu(CC.MainSubMenuX,nexty);
    if r==1 then
        DrawStrBoxWaitKey("��Ǹ��û������Ϸ���в���ȥ",C_WHITE,CC.DefaultFont,1);
    elseif r>1 then
        local personid=JY.Base["����" .. r];
        for i,v in ipairs(CC.PersonExit) do         --������б��е�����Ӻ���
             if personid==v[1] then
                 oldCallEvent(v[2]);
             end
        end
    end
    Cls();
    return 0;
end

--����ѡ������˵�
function SelectTeamMenu(x,y)          --����ѡ������˵�
	local menu={};
	for i=1,CC.TeamNum do
        menu[i]={"",nil,0};
		local id=JY.Base["����" .. i]
		if id>=0 then
            if JY.Person[id]["����"]>0 then
                menu[i][1]=JY.Person[id]["����"];
                menu[i][3]=1;
            end
		end
	end
    return ShowMenu(menu,CC.TeamNum,0,x,y,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
end

function GetTeamNum()            --�õ����Ѹ���
    local r=CC.TeamNum;
	for i=1,CC.TeamNum do
	    if JY.Base["����" .. i]<0 then
		    r=i-1;
		    break;
		end
    end
	return r;
end

---��ʾ����״̬
-- ���Ҽ���ҳ�����¼�������
function ShowPersonStatus(teamid)---��ʾ����״̬
	local page=1;
	local pagenum=2;
	local teamnum=GetTeamNum();

	while true do
	    Cls();
        local id=JY.Base["����" .. teamid];
        ShowPersonStatus_sub(id,page);

        ShowScreen();
	    local keypress=WaitKey();
        lib.Delay(100);
        if keypress==VK_ESCAPE then
            break;
        elseif keypress==VK_UP then
		    teamid=teamid-1;
        elseif keypress==VK_DOWN then
		    teamid=teamid+1;
        elseif keypress==VK_LEFT then
		    page=page-1;
        elseif keypress==VK_RIGHT then
		    page=page+1;
        end
		teamid=limitX(teamid,1,teamnum);
		page=limitX(page,1,pagenum);
	end
end

--id ������
--page ��ʾҳ����Ŀǰ����ҳ
function ShowPersonStatus_sub(id,page)    --��ʾ����״̬ҳ��
    local size=CC.DefaultFont;    --�����С
    local p=JY.Person[id];
    local width=18*size+15;             --18�������ַ���
	local h=size+CC.PersonStateRowPixel;
	local height=13*h+10;                --12�������ַ���
	local dx=(CC.ScreenW-width)/2;
	local dy=(CC.ScreenH-height)/2;

	local i=1;
    local x1,y1,x2;

    DrawBox(dx,dy,dx+width,dy+height,C_WHITE);

    x1=dx+5;
	y1=dy+5;
	x2=4*size;
	local headw,headh=lib.PicGetXY(1,p["ͷ�����"]*2);
    local headx=(width/2-headw)/2;
	local heady=(h*6-headh)/2;


    lib.PicLoadCache(1,p["ͷ�����"]*2,x1+headx,y1+heady,1);
    i=6;
    DrawString(x1,y1+h*i,p["����"],C_WHITE,size);
    DrawString(x1+10*size/2,y1+h*i,string.format("%3d",p["�ȼ�"]),C_GOLD,size);
    DrawString(x1+13*size/2,y1+h*i,"��",C_ORANGE,size);

	local function DrawAttrib(str,color1,color2,v)    --�����ڲ�����
        v=v or 0;
        DrawString(x1,y1+h*i,str,color1,size);
        DrawString(x1+x2,y1+h*i,string.format("%5d",p[str]+v),color2,size);
        i=i+1;
    end

if page==1 then
    local color;              --��ʾ���������ֵ���������˺��ж���ʾ��ͬ��ɫ
    if p["���˳̶�"]<33 then
        color =RGB(236,200,40);
    elseif p["���˳̶�"]<66 then
        color=RGB(244,128,32);
    else
        color=RGB(232,32,44);
    end
	i=i+1;
    DrawString(x1,y1+h*i,"����",C_ORANGE,size);
    DrawString(x1+2*size,y1+h*i,string.format("%5d",p["����"]),color,size);
    DrawString(x1+9*size/2,y1+h*i,"/",C_GOLD,size);

    if p["�ж��̶�"]==0 then
        color =RGB(252,148,16);
    elseif p["�ж��̶�"]<50 then
        color=RGB(120,208,88);
    else
        color=RGB(56,136,36);
    end
    DrawString(x1+5*size,y1+h*i,string.format("%5s",p["�������ֵ"]),color,size);

    i=i+1;              --��ʾ���������ֵ����������������ʾ��ͬ��ɫ
    if p["��������"]==0 then
        color=RGB(208,152,208);
    elseif p["��������"]==1 then
        color=RGB(236,200,40);
    else
        color=RGB(236,236,236);
    end
    DrawString(x1,y1+h*i,"����",C_ORANGE,size);
    DrawString(x1+2*size,y1+h*i,string.format("%5d/%5d",p["����"],p["�������ֵ"]),color,size);

    i=i+1;
    DrawAttrib("����",C_ORANGE,C_GOLD)
    DrawAttrib("����",C_ORANGE,C_GOLD)
    local tmp;
	if p["�ȼ�"] >=CC.Level then
	    tmp="=";
	else
        tmp=string.format("%5d",CC.Exp[p["�ȼ�"]]);
	end

    DrawString(x1,y1+h*i,"����",C_ORANGE,size);
    DrawString(x1+x2,y1+h*i,tmp,C_GOLD,size);

    local tmp1,tmp2,tmp3=0,0,0;
    if p["����"]>-1 then
        tmp1=tmp1+JY.Thing[p["����"]]["�ӹ�����"];
        tmp2=tmp2+JY.Thing[p["����"]]["�ӷ�����"];
        tmp3=tmp3+JY.Thing[p["����"]]["���Ṧ"];
	end
    if p["����"]>-1 then
        tmp1=tmp1+JY.Thing[p["����"]]["�ӹ�����"];
        tmp2=tmp2+JY.Thing[p["����"]]["�ӷ�����"];
        tmp3=tmp3+JY.Thing[p["����"]]["���Ṧ"];
	end

    i=i+1;
    DrawString(x1,y1+h*i,"���Ҽ���ҳ�����¼��鿴��������",C_RED,size);


    i=0;
	x1=dx+width/2;
    DrawAttrib("������",C_WHITE,C_GOLD,tmp1);
    DrawAttrib("������",C_WHITE,C_GOLD,tmp2);
    DrawAttrib("�Ṧ",C_WHITE,C_GOLD,tmp3);

    DrawAttrib("ҽ������",C_WHITE,C_GOLD);
    DrawAttrib("�ö�����",C_WHITE,C_GOLD);
    DrawAttrib("�ⶾ����",C_WHITE,C_GOLD);


    DrawAttrib("ȭ�ƹ���",C_WHITE,C_GOLD);
    DrawAttrib("��������",C_WHITE,C_GOLD);
    DrawAttrib("ˣ������",C_WHITE,C_GOLD);
    DrawAttrib("�������",C_WHITE,C_GOLD);
    DrawAttrib("��������",C_WHITE,C_GOLD);
    DrawAttrib("����",C_WHITE,C_GOLD);

elseif page==2 then
	i=i+1;
    DrawString(x1,y1+h*i,"����:",C_ORANGE,size);
	if p["����"]>-1 then
        DrawString(x1+size*3,y1+h*i,JY.Thing[p["����"]]["����"],C_GOLD,size);
    end
	i=i+1;
    DrawString(x1,y1+h*i,"����:",C_ORANGE,size);
	if p["����"]>-1 then
        DrawString(x1+size*3,y1+h*i,JY.Thing[p["����"]]["����"],C_GOLD,size);
    end
    i=i+1;
    DrawString(x1,y1+h*i,"������Ʒ",C_ORANGE,size);
	local thingid=p["������Ʒ"];
	if thingid>0 then
	    i=i+1;
        DrawString(x1+size,y1+h*i,JY.Thing[thingid]["����"],C_GOLD,size);
		i=i+1;
        local n=TrainNeedExp(id);
		if n <math.huge then
            DrawString(x1+size,y1+h*i,string.format("%5d/%5d",p["��������"],n),C_GOLD,size);
		else
            DrawString(x1+size,y1+h*i,string.format("%5d/===",p["��������"]),C_GOLD,size);
		end
	else
	    i=i+2;
	end

    i=i+1;
    DrawString(x1,y1+h*i,"���Ҽ���ҳ�����¼��鿴��������",C_RED,size);

    i=0;
	x1=dx+width/2;
    DrawString(x1,y1+h*i,"���Ṧ��",C_ORANGE,size);
	for j=1,10 do
        i=i+1
		local wugong=p["�书" .. j];
		if wugong > 0 then
    		local level=math.modf(p["�书�ȼ�" .. j] / 100)+1;
            DrawString(x1+size,y1+h*i,string.format("%s",JY.Wugong[wugong]["����"]),C_GOLD,size);
            DrawString(x1+size*7,y1+h*i,string.format("%2d",level),C_WHITE,size);
		end
	end

end

end


--�������������ɹ���Ҫ�ĵ���
--id ����id
function TrainNeedExp(id)         --��������������Ʒ�ɹ���Ҫ�ĵ���
    local thingid=JY.Person[id]["������Ʒ"];
	local r =0;
	if thingid >= 0 then
        if JY.Thing[thingid]["�����书"] >=0 then
            local level=0;          --�˴���level��ʵ��level-1������û���书�r������һ����һ���ġ�
			for i =1,10 do               -- ���ҵ�ǰ�Ѿ������书�ȼ�
			    if JY.Person[id]["�书" .. i]==JY.Thing[thingid]["�����书"] then
                    level=math.modf(JY.Person[id]["�书�ȼ�" .. i] /100);
					break;
                end
            end
			if level <9 then
                r=(7-math.modf(JY.Person[id]["����"]/15))*JY.Thing[thingid]["�辭��"]*(level+1);
			else
                r=math.huge;
			end
		else
            r=(7-math.modf(JY.Person[id]["����"]/15))*JY.Thing[thingid]["�辭��"]*2;
		end
	end
    return r;
end

--ҽ�Ʋ˵�
function Menu_Doctor()       --ҽ�Ʋ˵�
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"˭Ҫʹ��ҽ��",C_WHITE,CC.DefaultFont);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
    DrawStrBox(CC.MainSubMenuX,nexty,"ҽ������",C_ORANGE,CC.DefaultFont);

	local menu1={};
	for i=1,CC.TeamNum do
        menu1[i]={"",nil,0};
		local id=JY.Base["����" .. i]
        if id >=0 then
            if JY.Person[id]["ҽ������"]>=20 then
                 menu1[i][1]=string.format("%-10s%4d",JY.Person[id]["����"],JY.Person[id]["ҽ������"]);
                 menu1[i][3]=1;
            end
        end
	end

    local id1,id2;
	nexty=nexty+CC.SingleLineHeight;
    local r=ShowMenu(menu1,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r >0 then
	    id1=JY.Base["����" .. r];
        Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
        DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"Ҫҽ��˭",C_WHITE,CC.DefaultFont);
        nexty=CC.MainSubMenuY+CC.SingleLineHeight;

		local menu2={};
		for i=1,CC.TeamNum do
			menu2[i]={"",nil,0};
			local id=JY.Base["����" .. i]
			if id>=0 then
				 menu2[i][1]=string.format("%-10s%4d/%4d",JY.Person[id]["����"],JY.Person[id]["����"],JY.Person[id]["�������ֵ"]);
				 menu2[i][3]=1;
			end
		end

		local r2=ShowMenu(menu2,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE,C_WHITE);

		if r2 >0 then
	        id2=JY.Base["����" .. r2];
            local num=ExecDoctor(id1,id2);
			if num>0 then
                AddPersonAttrib(id1,"����",-2);
			end
            DrawStrBoxWaitKey(string.format("%s �������� %d",JY.Person[id2]["����"],num),C_ORANGE,CC.DefaultFont);
		end
	end

	Cls();

    return 0;
end

--ִ��ҽ��
--id1 ҽ��id2, ����id2�������ӵ���
function ExecDoctor(id1,id2)      --ִ��ҽ��
	if JY.Person[id1]["����"]<50 then
        return 0;
	end

	local add=JY.Person[id1]["ҽ������"];
    local value=JY.Person[id2]["���˳̶�"];
    if value > add+20 then
        return 0;
	end

    if value <25 then    --�������˳̶ȼ���ʵ��ҽ������
        add=add*4/5;
	elseif value <50 then
        add=add*3/4;
	elseif value <75 then
        add=add*2/3;
	else
        add=add/2;
	end
 	add=math.modf(add)+Rnd(5);

    AddPersonAttrib(id2,"���˳̶�",-add);
    return AddPersonAttrib(id2,"����",add)
end

--�ⶾ
function Menu_DecPoison()         --�ⶾ
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"˭Ҫ���˽ⶾ",C_WHITE,CC.DefaultFont);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
    DrawStrBox(CC.MainSubMenuX,nexty,"�ⶾ����",C_ORANGE,CC.DefaultFont);

	local menu1={};
	for i=1,CC.TeamNum do
        menu1[i]={"",nil,0};
		local id=JY.Base["����" .. i]
        if id>=0 then
            if JY.Person[id]["�ⶾ����"]>=20 then
                 menu1[i][1]=string.format("%-10s%4d",JY.Person[id]["����"],JY.Person[id]["�ⶾ����"]);
                 menu1[i][3]=1;
            end
        end
	end

    local id1,id2;
 	nexty=nexty+CC.SingleLineHeight;
    local r=ShowMenu(menu1,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r >0 then
	    id1=JY.Base["����" .. r];
         Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
        DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"��˭�ⶾ",C_WHITE,CC.DefaultFont);
		nexty=CC.MainSubMenuY+CC.SingleLineHeight;

        DrawStrBox(CC.MainSubMenuX,nexty,"�ж��̶�",C_WHITE,CC.DefaultFont);
	    nexty=nexty+CC.SingleLineHeight;

		local menu2={};
		for i=1,CC.TeamNum do
			menu2[i]={"",nil,0};
			local id=JY.Base["����" .. i]
			if id>=0 then
				 menu2[i][1]=string.format("%-10s%5d",JY.Person[id]["����"],JY.Person[id]["�ж��̶�"]);
				 menu2[i][3]=1;
			end
		end

		local r2=ShowMenu(menu2,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
		if r2 >0 then
	        id2=JY.Base["����" .. r2];
            local num=ExecDecPoison(id1,id2);
            DrawStrBoxWaitKey(string.format("%s �ж��̶ȼ��� %d",JY.Person[id2]["����"],num),C_ORANGE,CC.DefaultFont);
		end
	end
    Cls();
    return 0;
end

--�ⶾ
--id1 �ⶾid2, ����id2�ж����ٵ���
function ExecDecPoison(id1,id2)     --ִ�нⶾ
    local add=JY.Person[id1]["�ⶾ����"];
    local value=JY.Person[id2]["�ж��̶�"];

    if value > add+20 then
        return 0;
	end

 	add=limitX(math.modf(add/3)+Rnd(10)-Rnd(10),0,value);
    return -AddPersonAttrib(id2,"�ж��̶�",-add);
end

--��Ʒ�˵�
function Menu_Thing()       --��Ʒ�˵�

    local menu={ {"ȫ����Ʒ",nil,1},
                 {"������Ʒ",nil,1},
                 {"�������",nil,1},
                 {"�书����",nil,1},
                 {"�鵤��ҩ",nil,1},
                 {"���˰���",nil,1}, };

    local r=ShowMenu(menu,CC.TeamNum,0,CC.MainSubMenuX,CC.MainSubMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

	if r>0 then
        local thing={};
        local thingnum={};

		for i = 0,CC.MyThingNum-1 do
			thing[i]=-1;
			thingnum[i]=0;
		end

        local num=0
		for i = 0,CC.MyThingNum-1 do
		    local id=JY.Base["��Ʒ" .. i+1];
			if id>=0 then
				if r==1 then
					thing[i]=id
					thingnum[i]=JY.Base["��Ʒ����" ..i+1];
				else
					if JY.Thing[id]["����"]==r-2 then             --��Ӧ������0-4
 					    thing[num]=id;
					    thingnum[num]=JY.Base["��Ʒ����" ..i+1];
						num=num+1;
					end
				end
			end
		end

        local r=SelectThing(thing,thingnum);
        if r>=0 then
            UseThing(r);           --ʹ����Ʒ
			return 1;             --�˳����˵�
		end
	end
	return 0;
end

--�µ���ʾ��Ʒ�˵���ģ��ԭ��Ϸ
--��ʾ��Ʒ�˵�
--����ѡ�����Ʒ���, -1��ʾû��ѡ��
function SelectThing(thing,thingnum)    --��ʾ��Ʒ�˵�

    local xnum=CC.MenuThingXnum;
    local ynum=CC.MenuThingYnum;

	local w=CC.ThingPicWidth*xnum+(xnum-1)*CC.ThingGapIn+2*CC.ThingGapOut;  --������
	local h=CC.ThingPicHeight*ynum+(ynum-1)*CC.ThingGapIn+2*CC.ThingGapOut; --��Ʒ���߶�

	local dx=(CC.ScreenW-w)/2;
	local dy=(CC.ScreenH-h-2*(CC.ThingFontSize+2*CC.MenuBorderPixel+5))/2;


    local y1_1,y1_2,y2_1,y2_2,y3_1,y3_2;                  --���ƣ�˵����ͼƬ��Y����

    local cur_line=0;
    local cur_x=0;
    local cur_y=0;
    local cur_thing=-1;

	while true do
	    Cls();
		y1_1=dy;
        y1_2=y1_1+CC.ThingFontSize+2*CC.MenuBorderPixel;
        DrawBox(dx,y1_1,dx+w,y1_2,C_WHITE);
		y2_1=y1_2+5
		y2_2=y2_1+CC.ThingFontSize+2*CC.MenuBorderPixel
        DrawBox(dx,y2_1,dx+w,y2_2,C_WHITE);
        y3_1=y2_2+5;
        y3_2=y3_1+h;
		DrawBox(dx,y3_1,dx+w,y3_2,C_WHITE);

        for y=0,ynum-1 do
            for x=0,xnum-1 do
                local id=y*xnum+x+xnum*cur_line         --��ǰ��ѡ����Ʒ
				local boxcolor;
                if x==cur_x and y==cur_y then
				    boxcolor=C_WHITE;
                    if thing[id]>=0 then
                        cur_thing=thing[id];
                        local str=JY.Thing[thing[id]]["����"];
                        if JY.Thing[thing[id]]["����"]==1 or JY.Thing[thing[id]]["����"]==2 then
                            if JY.Thing[thing[id]]["ʹ����"] >=0 then
                                str=str .. "(" .. JY.Person[JY.Thing[thing[id]]["ʹ����"]]["����"] .. ")";
                            end
                        end
                        str=string.format("%s X %d",str,thingnum[id]);
						local str2=JY.Thing[thing[id]]["��Ʒ˵��"];

     			        DrawString(dx+CC.ThingGapOut,y1_1+CC.MenuBorderPixel,str,C_GOLD,CC.ThingFontSize);
     			        DrawString(dx+CC.ThingGapOut,y2_1+CC.MenuBorderPixel,str2,C_ORANGE,CC.ThingFontSize);

                    else
                        cur_thing=-1;
                    end
                else
 				    boxcolor=C_BLACK;
                end
				local boxx=dx+CC.ThingGapOut+x*(CC.ThingPicWidth+CC.ThingGapIn);
				local boxy=y3_1+CC.ThingGapOut+y*(CC.ThingPicHeight+CC.ThingGapIn);
                lib.DrawRect(boxx,boxy,boxx+CC.ThingPicWidth+1,boxy+CC.ThingPicHeight+1,boxcolor);
                if thing[id]>=0 then
				    if CC.LoadThingPic==1 then
					    lib.PicLoadCache(2,thing[id]*2,boxx+1,boxy+1,1);
					else
                        lib.PicLoadCache(0,(thing[id]+CC.StartThingPic)*2,boxx+1,boxy+1,1);
					end
                end
            end
        end

        ShowScreen();
	    local keypress=WaitKey();
        lib.Delay(100);
        if keypress==VK_ESCAPE then
            cur_thing=-1;
            break;
        elseif keypress==VK_RETURN or keypress==VK_SPACE then
            break;
        elseif keypress==VK_UP then
            if  cur_y == 0 then
                if  cur_line > 0 then
                    cur_line = cur_line - 1;
                end
            else
                cur_y = cur_y - 1;
            end
        elseif keypress==VK_DOWN then
            if  cur_y ==ynum-1 then
                if  cur_line < (math.modf(200/xnum)-ynum) then
                    cur_line = cur_line + 1;
                end
            else
                cur_y = cur_y + 1;
            end
        elseif keypress==VK_LEFT then
            if  cur_x > 0 then
                cur_x=cur_x-1;
            else
                cur_x=xnum-1;
            end
        elseif keypress==VK_RIGHT then
            if  cur_x ==xnum-1 then
                cur_x=0;
            else
                cur_x=cur_x+1;
            end
        end

	end

    Cls();
    return cur_thing;
end


--��������������
function Game_SMap()         --��������������

	DrawSMap(CONFIG.FastShowScreen);
	if CC.ShowXY==1 then
		DrawString(10,CC.ScreenH-20,string.format("%s %d %d",JY.Scene[JY.SubScene]["����"],JY.Base["��X1"],JY.Base["��Y1"]) ,C_GOLD,16);
	end

	ShowScreen(CONFIG.FastShowScreen);

	lib.SetClip(0,0,0,0);

    local d_pass=GetS(JY.SubScene,JY.Base["��X1"],JY.Base["��Y1"],3);   --��ǰ·���¼�
    if d_pass>=0 then
        if d_pass ~=JY.OldDPass then     --�����ظ�����
            EventExecute(d_pass,3);       --·�������¼�
            JY.OldDPass=d_pass;
		    JY.oldSMapX=-1;
	        JY.oldSMapY=-1;
			JY.D_Valid=nil;
        end
    else
        JY.OldDPass=-1;
    end

    local isout=0;                --�Ƿ���������
    if (JY.Scene[JY.SubScene]["����X1"] ==JY.Base["��X1"] and JY.Scene[JY.SubScene]["����Y1"] ==JY.Base["��Y1"]) or
       (JY.Scene[JY.SubScene]["����X2"] ==JY.Base["��X1"] and JY.Scene[JY.SubScene]["����Y2"] ==JY.Base["��Y1"]) or
       (JY.Scene[JY.SubScene]["����X3"] ==JY.Base["��X1"] and JY.Scene[JY.SubScene]["����Y3"] ==JY.Base["��Y1"]) then
       isout=1;
    end

    if isout==1 then    --��ȥ����������ͼ
        JY.Status=GAME_MMAP;

		lib.PicInit();
		CleanMemory();
        lib.ShowSlow(50,1)

        if JY.MMAPMusic<0 then
            JY.MMAPMusic=JY.Scene[JY.SubScene]["��������"];
        end

		Init_MMap();



        JY.SubScene=-1;
		JY.oldSMapX=-1;
		JY.oldSMapY=-1;

        lib.DrawMMap(JY.Base["��X"],JY.Base["��Y"],GetMyPic());
        lib.ShowSlow(50,0)
        lib.GetKey();
        return;
    end

    --�Ƿ���ת����������
    if JY.Scene[JY.SubScene]["��ת����"] >=0 then
        if JY.Base["��X1"]==JY.Scene[JY.SubScene]["��ת��X1"] and JY.Base["��Y1"]==JY.Scene[JY.SubScene]["��ת��Y1"] then
            JY.SubScene=JY.Scene[JY.SubScene]["��ת����"];
            lib.ShowSlow(50,1);

            if JY.Scene[JY.SubScene]["�⾰���X1"]==0 and JY.Scene[JY.SubScene]["�⾰���Y1"]==0 then
                JY.Base["��X1"]=JY.Scene[JY.SubScene]["���X"];            --�³������⾰���Ϊ0����ʾ����һ���ڲ�����
                JY.Base["��Y1"]=JY.Scene[JY.SubScene]["���Y"];
            else
                JY.Base["��X1"]=JY.Scene[JY.SubScene]["��ת��X2"];         --�ⲿ���������������ڲ��������ء�
                JY.Base["��Y1"]=JY.Scene[JY.SubScene]["��ת��Y2"];
            end

			Init_SMap(1);

            return;
        end
    end

    local x,y;
    local keypress = lib.GetKey();
    local direct=-1;
    if keypress ~= -1 then
		JY.MyTick=0;
		if keypress==VK_ESCAPE then
			MMenu();
			JY.oldSMapX=-1;
	        JY.oldSMapY=-1;
		elseif keypress==VK_UP then
			direct=0;
		elseif keypress==VK_DOWN then
			direct=3;
		elseif keypress==VK_LEFT then
			direct=2;
		elseif keypress==VK_RIGHT then
			direct=1;
		elseif keypress==VK_SPACE or keypress==VK_RETURN  then
            if JY.Base["�˷���"]>=0 then        --��ǰ������һ��λ��
                local d_num=GetS(JY.SubScene,JY.Base["��X1"]+CC.DirectX[JY.Base["�˷���"]+1],JY.Base["��Y1"]+CC.DirectY[JY.Base["�˷���"]+1],3);
                if d_num>=0 then
                    EventExecute(d_num,1);       --�ո񴥷��¼�
					JY.oldSMapX=-1;
					JY.oldSMapY=-1;
					JY.D_Valid=nil;
                end
            end
		end
    end

    if JY.Status~=GAME_SMAP then
        return ;
    end

    if direct ~= -1 then
        AddMyCurrentPic();
        x=JY.Base["��X1"]+CC.DirectX[direct+1];
        y=JY.Base["��Y1"]+CC.DirectY[direct+1];
        JY.Base["�˷���"]=direct;
    else
        x=JY.Base["��X1"];
        y=JY.Base["��Y1"];
    end

    JY.MyPic=GetMyPic();

    DtoSMap();

    if SceneCanPass(x,y)==true then          --�µ���������߹�ȥ
        JY.Base["��X1"]=x;
        JY.Base["��Y1"]=y;
    end

    JY.Base["��X1"]=limitX(JY.Base["��X1"],1,CC.SWidth-2);
    JY.Base["��Y1"]=limitX(JY.Base["��Y1"],1,CC.SHeight-2);

end

--��������(x,y)�Ƿ����ͨ��
--����true,���ԣ�false����
function SceneCanPass(x,y)  --��������(x,y)�Ƿ����ͨ��
    local ispass=true;        --�Ƿ����ͨ��

    if GetS(JY.SubScene,x,y,1)>0 then     --������1����Ʒ������ͨ��
        ispass=false;
    end

    local d_data=GetS(JY.SubScene,x,y,3);     --�¼���4
    if d_data>=0 then
        if GetD(JY.SubScene,d_data,0)~=0 then  --d*����Ϊ����ͨ��
            ispass=false;
        end
    end

    if CC.SceneWater[GetS(JY.SubScene,x,y,0)] ~= nil then   --ˮ�棬���ɽ���
        ispass=false;
    end
    return ispass;
end


function Cal_D_Valid()     --����200��D����Ч��D
    if JY.D_Valid~=nil then
	    return ;
	end

    local sceneid=JY.SubScene;
	JY.D_Valid={};
	JY.D_Valid_Num=0;
    for i=0,CC.DNum-1 do
        local x=GetD(sceneid,i,9);
        local y=GetD(sceneid,i,10);
        local v=GetS(sceneid,x,y,3);
		if v>=0 then
            JY.D_Valid[JY.D_Valid_Num]=i;
			JY.D_Valid_Num=JY.D_Valid_Num+1;
		end
	end
end

function DtoSMap()          ---D*�е��¼�������Ч����
    local sceneid=JY.SubScene;
    JY.NumD_PicChange=0;
    JY.D_PicChange={};

	if JY.D_Valid==nil then
	    Cal_D_Valid();
	end

	for k=0,JY.D_Valid_Num-1 do
	    local i=JY.D_Valid[k];

		local p1=GetD(sceneid,i,5);
		if p1>0 then
			local p2=GetD(sceneid,i,6);
			local p3=GetD(sceneid,i,7);
			if p1 ~= p2 then
				local old_p3=p3;
				local delay=GetD(sceneid,i,8);
				if not (p3>=CC.SceneFlagPic[1]*2 and p3<=CC.SceneFlagPic[2]*2 and CC.ShowFlag==0) then --�Ƿ���ʾ����
					if p3<=p1 then     --������ֹͣ
						if JY.MyTick2 %100 > delay then
							p3=p3+2;
						end
					else
						if JY.MyTick2 % 4 ==0 then      --4�����Ķ�������һ��
							p3=p3+2;
						end
					end
					if p3>p2 then
						 p3=p1;
					end
				end
				if old_p3 ~=p3 then    --�����ı��ˣ�����һ��
                    local x=GetD(sceneid,i,9);
                    local y=GetD(sceneid,i,10);
					local dy=GetS(sceneid,x,y,4);       --����
					JY.D_PicChange[JY.NumD_PicChange]={x=x, y=y, dy=dy, p1=old_p3/2, p2=p3/2}
					JY.NumD_PicChange=JY.NumD_PicChange+1;
					SetD(sceneid,i,7,p3);
				end
			end
		end
    end
end

--fastdraw = 0 or nil ȫ���ػ档�����¼���
--           1 ��������� ������ʾ����ѭ��
function DrawSMap(fastdraw)         --�泡����ͼ
    if fastdraw==nil then
	    fastdraw=0;
	end
	local x0=JY.SubSceneX+JY.Base["��X1"]-1;    --��ͼ���ĵ�
	local y0=JY.SubSceneY+JY.Base["��Y1"]-1;

	local x=limitX(x0,CC.SceneXMin,CC.SceneXMax)-JY.Base["��X1"];
	local y=limitX(y0,CC.SceneYMin,CC.SceneYMax)-JY.Base["��Y1"];

    if fastdraw==0 then
		lib.DrawSMap(JY.SubScene,JY.Base["��X1"],JY.Base["��Y1"],x,y,JY.MyPic);
    else
		if JY.oldSMapX>=0 and JY.oldSMapY>=0 and
		   JY.oldSMapX+JY.oldSMapXoff==JY.Base["��X1"]+x and         --��ͼ���ĵ㲻�䣬����·Ҳ�����òü���ʽ��ͼ
		   JY.oldSMapY+JY.oldSMapYoff==JY.Base["��Y1"]+y then

			local num_clip=0;
			local clip={};

			for i=0,JY.NumD_PicChange-1 do   --����D*����ͼ�ı�ľ���
			    local dx=JY.D_PicChange[i].x-JY.Base["��X1"]-x;
				local dy=JY.D_PicChange[i].y-JY.Base["��Y1"]-y;
				clip[num_clip]=Cal_PicClip(dx,dy,JY.D_PicChange[i].p1,0,
										   dx,dy,JY.D_PicChange[i].p2,0 );
				clip[num_clip].y1=clip[num_clip].y1-JY.D_PicChange[i].dy
				clip[num_clip].y2=clip[num_clip].y2-JY.D_PicChange[i].dy
				num_clip=num_clip+1;
			end

			if JY.oldSMapPic>=0 then  --�������Ǿ���
			    if not ( JY.oldSMapX==JY.Base["��X1"] and    --�����б仯
				         JY.oldSMapY==JY.Base["��Y1"] and
						 JY.oldSMapPic==JY.MyPic ) then
					local dy1=GetS(JY.SubScene,JY.Base["��X1"],JY.Base["��Y1"],4);   --����
					local dy2=GetS(JY.SubScene,JY.oldSMapX,JY.oldSMapY,4);
					local dy=math.max(dy1,dy2);
					clip[num_clip]=Cal_PicClip(-JY.oldSMapXoff,-JY.oldSMapYoff,JY.oldSMapPic,0,
												-x,-y,JY.MyPic,0)
					clip[num_clip].y1=clip[num_clip].y1- dy;
					clip[num_clip].y2=clip[num_clip].y2- dy;
					num_clip=num_clip+1;
				end
			end

			local area=0;          --����������������
			for i=0,num_clip-1 do
				clip[i]=ClipRect(clip[i]);    --������Ļ����
				if clip[i]~=nil then
					area=area+(clip[i].x2-clip[i].x1)*(clip[i].y2-clip[i].y1)
				end
			end

			if area <CC.ScreenW*CC.ScreenH/2 and num_clip<15 then        --����㹻С��������Ŀ�٣����������Ρ�
				for i=0,num_clip-1 do
					if clip[i]~=nil then
						lib.SetClip(clip[i].x1,clip[i].y1,clip[i].x2,clip[i].y2);
						lib.DrawSMap(JY.SubScene,JY.Base["��X1"],JY.Base["��Y1"],x,y,JY.MyPic);
					end
				end
			else    --���̫��ֱ���ػ�
				lib.SetClip(0,0,CC.ScreenW,CC.ScreenH);   --����redraw=0����������ü������Ժ����ShowSurface
				lib.DrawSMap(JY.SubScene,JY.Base["��X1"],JY.Base["��Y1"],x,y,JY.MyPic);
			end
		else
			lib.SetClip(0,0,CC.ScreenW,CC.ScreenH);
			lib.DrawSMap(JY.SubScene,JY.Base["��X1"],JY.Base["��Y1"],x,y,JY.MyPic);
		end
    end

	JY.oldSMapX=JY.Base["��X1"];
	JY.oldSMapY=JY.Base["��Y1"];
	JY.oldSMapPic=JY.MyPic;
    JY.oldSMapXoff=x;
    JY.oldSMapYoff=y;
end


-- ��ȡ��Ϸ����
-- id=0 �½��ȣ�=1/2/3 ����
--
--�������Ȱ����ݶ���Byte�����С�Ȼ���������Ӧ��ķ������ڷ��ʱ�ʱֱ�Ӵ�������ʡ�
--����ǰ��ʵ����ȣ����ļ��ж�ȡ�ͱ��浽�ļ���ʱ�������ӿ졣�����ڴ�ռ������
function LoadRecord(id)       -- ��ȡ��Ϸ����
    local t1=lib.GetTime();

    --��ȡR*.idx�ļ�
    local data=Byte.create(6*4);
    Byte.loadfile(data,CC.R_IDXFilename[id],0,6*4);

	local idx={};
	idx[0]=0;
	for i =1,6 do
	    idx[i]=Byte.get32(data,4*(i-1));
	end

    --��ȡR*.grp�ļ�
    JY.Data_Base=Byte.create(idx[1]-idx[0]);              --��������
    Byte.loadfile(JY.Data_Base,CC.R_GRPFilename[id],idx[0],idx[1]-idx[0]);

    --���÷��ʻ������ݵķ����������Ϳ����÷��ʱ�ķ�ʽ�����ˡ������ðѶ���������ת��Ϊ����Լ����ʱ��Ϳռ�
	local meta_t={
	    __index=function(t,k)
	        return GetDataFromStruct(JY.Data_Base,0,CC.Base_S,k);
		end,

		__newindex=function(t,k,v)
	        SetDataFromStruct(JY.Data_Base,0,CC.Base_S,k,v);
	 	end
	}
    setmetatable(JY.Base,meta_t);


    JY.PersonNum=math.floor((idx[2]-idx[1])/CC.PersonSize);   --����

	JY.Data_Person=Byte.create(CC.PersonSize*JY.PersonNum);
	Byte.loadfile(JY.Data_Person,CC.R_GRPFilename[id],idx[1],CC.PersonSize*JY.PersonNum);

	for i=0,JY.PersonNum-1 do
		JY.Person[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k,v);
			end
		}
        setmetatable(JY.Person[i],meta_t);
	end

    JY.ThingNum=math.floor((idx[3]-idx[2])/CC.ThingSize);     --��Ʒ
	JY.Data_Thing=Byte.create(CC.ThingSize*JY.ThingNum);
	Byte.loadfile(JY.Data_Thing,CC.R_GRPFilename[id],idx[2],CC.ThingSize*JY.ThingNum);
	for i=0,JY.ThingNum-1 do
		JY.Thing[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Thing,i*CC.ThingSize,CC.Thing_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Thing,i*CC.ThingSize,CC.Thing_S,k,v);
			end
		}
        setmetatable(JY.Thing[i],meta_t);
	end

    JY.SceneNum=math.floor((idx[4]-idx[3])/CC.SceneSize);     --����
	JY.Data_Scene=Byte.create(CC.SceneSize*JY.SceneNum);
	Byte.loadfile(JY.Data_Scene,CC.R_GRPFilename[id],idx[3],CC.SceneSize*JY.SceneNum);
	for i=0,JY.SceneNum-1 do
		JY.Scene[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Scene,i*CC.SceneSize,CC.Scene_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Scene,i*CC.SceneSize,CC.Scene_S,k,v);
			end
		}
        setmetatable(JY.Scene[i],meta_t);
	end

    JY.WugongNum=math.floor((idx[5]-idx[4])/CC.WugongSize);     --�书
	JY.Data_Wugong=Byte.create(CC.WugongSize*JY.WugongNum);
	Byte.loadfile(JY.Data_Wugong,CC.R_GRPFilename[id],idx[4],CC.WugongSize*JY.WugongNum);
	for i=0,JY.WugongNum-1 do
		JY.Wugong[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Wugong,i*CC.WugongSize,CC.Wugong_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Wugong,i*CC.WugongSize,CC.Wugong_S,k,v);
			end
		}
        setmetatable(JY.Wugong[i],meta_t);
	end

    JY.ShopNum=math.floor((idx[6]-idx[5])/CC.ShopSize);     --С���̵�
	JY.Data_Shop=Byte.create(CC.ShopSize*JY.ShopNum);
	Byte.loadfile(JY.Data_Shop,CC.R_GRPFilename[id],idx[5],CC.ShopSize*JY.ShopNum);
	for i=0,JY.ShopNum-1 do
		JY.Shop[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Shop,i*CC.ShopSize,CC.Shop_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Shop,i*CC.ShopSize,CC.Shop_S,k,v);
			end
		}
        setmetatable(JY.Shop[i],meta_t);

    end

    lib.LoadSMap(CC.S_Filename[id],CC.TempS_Filename,JY.SceneNum,CC.SWidth,CC.SHeight,CC.D_Filename[id],CC.DNum,11);
	collectgarbage();

	lib.Debug(string.format("Loadrecord time=%d",lib.GetTime()-t1));
end

-- д��Ϸ����
-- id=0 �½��ȣ�=1/2/3 ����
function SaveRecord(id)         -- д��Ϸ����
    --��ȡR*.idx�ļ�
    local t1=lib.GetTime();

    local data=Byte.create(6*4);
    Byte.loadfile(data,CC.R_IDXFilename[id],0,6*4);

	local idx={};
	idx[0]=0;
	for i =1,6 do
	    idx[i]=Byte.get32(data,4*(i-1));
	end

    --дR*.grp�ļ�
    Byte.savefile(JY.Data_Base,CC.R_GRPFilename[id],idx[0],idx[1]-idx[0]);

	Byte.savefile(JY.Data_Person,CC.R_GRPFilename[id],idx[1],CC.PersonSize*JY.PersonNum);

	Byte.savefile(JY.Data_Thing,CC.R_GRPFilename[id],idx[2],CC.ThingSize*JY.ThingNum);

	Byte.savefile(JY.Data_Scene,CC.R_GRPFilename[id],idx[3],CC.SceneSize*JY.SceneNum);

	Byte.savefile(JY.Data_Wugong,CC.R_GRPFilename[id],idx[4],CC.WugongSize*JY.WugongNum);

	Byte.savefile(JY.Data_Shop,CC.R_GRPFilename[id],idx[5],CC.ShopSize*JY.ShopNum);

    lib.SaveSMap(CC.S_Filename[id],CC.D_Filename[id]);
    lib.Debug(string.format("SaveRecord time=%d",lib.GetTime()-t1));

end
-------------------------------------------------------------------------------------
-----------------------------------ͨ�ú���-------------------------------------------

function filelength(filename)         --�õ��ļ�����
    local inp=io.open(filename,"rb");
    local l= inp:seek("end");
	inp:close();
    return l;
end

--��S������, (x,y) ���꣬level �� 0-5
function GetS(id,x,y,level)       --��S������
    return lib.GetS(id,x,y,level);
end

--дS��
function SetS(id,x,y,level,v)       --дS��
    lib.SetS(id,x,y,level,v);
end

--��D*
--sceneid ������ţ�
--id D*���
--Ҫ���ڼ�������, 0-10
function GetD(Sceneid,id,i)          --��D*
    return lib.GetD(Sceneid,id,i);
end

--дD��
function SetD(Sceneid,id,i,v)         --дD��
    lib.SetD(Sceneid,id,i,v);
end

--�����ݵĽṹ�з�������
--data ����������
--offset data�е�ƫ��
--t_struct ���ݵĽṹ����jyconst���кܶඨ��
--key  ���ʵ�key
function GetDataFromStruct(data,offset,t_struct,key)  --�����ݵĽṹ�з������ݣ�����ȡ����
    local t=t_struct[key];
	local r;
	if t[2]==0 then
		r=Byte.get16(data,t[1]+offset);
	elseif t[2]==1 then
		r=Byte.getu16(data,t[1]+offset);
	elseif t[2]==2 then
		if CC.SrcCharSet==0 then
			r=lib.CharSet(Byte.getstr(data,t[1]+offset,t[3]),0);
		else
			r=Byte.getstr(data,t[1]+offset,t[3]);
		end
	end
	return r;
end

function SetDataFromStruct(data,offset,t_struct,key,v)  --�����ݵĽṹ�з������ݣ���������
    local t=t_struct[key];
	if t[2]==0 then
		Byte.set16(data,t[1]+offset,v);
	elseif t[2]==1 then
		Byte.setu16(data,t[1]+offset,v);
	elseif t[2]==2 then
		local s;
		if CC.SrcCharSet==0 then
			s=lib.CharSet(v,1);
		else
			s=v;
		end
		Byte.setstr(data,t[1]+offset,t[3],s);
	end
end

--����t_struct ����Ľṹ�����ݴ�data�����ƴ��ж�����t��
function LoadData(t,t_struct,data)        --data�����ƴ��ж�����t��
    for k,v in pairs(t_struct) do
        if v[2]==0 then
            t[k]=Byte.get16(data,v[1]);
        elseif v[2]==1 then
            t[k]=Byte.getu16(data,v[1]);
		elseif v[2]==2 then
            if CC.SrcCharSet==0 then
                t[k]=lib.CharSet(Byte.getstr(data,v[1],v[3]),0);
		    else
		        t[k]=Byte.getstr(data,v[1],v[3]);
		    end
		end
	end
end

--����t_struct ����Ľṹ������д��data Byte�����С�
function SaveData(t,t_struct,data)      --����д��data Byte�����С�
    for k,v in pairs(t_struct) do
        if v[2]==0 then
            Byte.set16(data,v[1],t[k]);
		elseif v[2]==1 then
            Byte.setu16(data,v[1],t[k]);
		elseif v[2]==2 then
		    local s;
			if CC.SrcCharSet==0 then
			    s=lib.CharSet(t[k],1);
            else
			    s=t[k];
		    end
            Byte.setstr(data,v[1],v[3],s);
		end
	end
end

function limitX(x,minv,maxv)       --����x�ķ�Χ
    if x<minv then
	    x=minv;
	elseif x>maxv then
	    x=maxv;
	end
	return x
end

function RGB(r,g,b)          --������ɫRGB
   return r*65536+g*256+b;
end

function GetRGB(color)      --������ɫ��RGB����
    color=color%(65536*256);
    local r=math.floor(color/65536);
    color=color%65536;
    local g=math.floor(color/256);
    local b=color%256;
    return r,g,b
end

--�ȴ���������
function WaitKey()       --�ȴ���������
    local keyPress=-1;
    while true do
		keyPress=lib.GetKey();
		if keyPress ~=-1 then
	         break;
	    end
        lib.Delay(20);
	end
	return keyPress;
end

--����һ���������İ�ɫ�����Ľǰ���
function DrawBox(x1,y1,x2,y2,color)         --����һ���������İ�ɫ����
    local s=4;
    lib.Background(x1,y1+s,x1+s,y2-s,128);    --��Ӱ���Ľǿճ�
    lib.Background(x1+s,y1,x2-s,y2,128);
    lib.Background(x2-s,y1+s,x2,y2-s,128);
    local r,g,b=GetRGB(color);
    DrawBox_1(x1+1,y1+1,x2,y2,RGB(math.modf(r/2),math.modf(g/2),math.modf(b/2)));
    DrawBox_1(x1,y1,x2-1,y2-1,color);
end

--�����Ľǰ����ķ���
function DrawBox_1(x1,y1,x2,y2,color)       --�����Ľǰ����ķ���
    local s=4;
    lib.DrawRect(x1+s,y1,x2-s,y1,color);
    lib.DrawRect(x2-s,y1,x2-s,y1+s,color);
    lib.DrawRect(x2-s,y1+s,x2,y1+s,color);
    lib.DrawRect(x2,y1+s,x2,y2-s,color);
    lib.DrawRect(x2,y2-s,x2-s,y2-s,color);
    lib.DrawRect(x2-s,y2-s,x2-s,y2,color);
    lib.DrawRect(x2-s,y2,x1+s,y2,color);
    lib.DrawRect(x1+s,y2,x1+s,y2-s,color);
    lib.DrawRect(x1+s,y2-s,x1,y2-s,color);
    lib.DrawRect(x1,y2-s,x1,y1+s,color);
    lib.DrawRect(x1,y1+s,x1+s,y1+s,color);
    lib.DrawRect(x1+s,y1+s,x1+s,y1,color);
end

--��ʾ��Ӱ�ַ���
function DrawString(x,y,str,color,size)         --��ʾ��Ӱ�ַ���
--    local r,g,b=GetRGB(color);
--    lib.DrawStr(x+1,y+1,str,RGB(math.modf(r/2),math.modf(g/2),math.modf(b/2)),size,CC.FontName,CC.SrcCharSet,CC.OSCharSet);
    lib.DrawStr(x,y,str,color,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet);
end

--��ʾ������ַ���
--(x,y) ���꣬�����Ϊ-1,������Ļ�м���ʾ
function DrawStrBox(x,y,str,color,size)         --��ʾ������ַ���
    local ll=#str;
    local w=size*ll/2+2*CC.MenuBorderPixel;
	local h=size+2*CC.MenuBorderPixel;
	if x==-1 then
        x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2;
	end
	if y==-1 then
        y=(CC.ScreenH-size-2*CC.MenuBorderPixel)/2;
	end

    DrawBox(x,y,x+w-1,y+h-1,C_WHITE);
    DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel,str,color,size);
end

--��ʾ��ѯ��Y/N��������Y���򷵻�true, N�򷵻�false
--(x,y) ���꣬�����Ϊ-1,������Ļ�м���ʾ
--��Ϊ�ò˵�ѯ���Ƿ�
function DrawStrBoxYesNo(x,y,str,color,size)        --��ʾ�ַ�����ѯ��Y/N
    lib.GetKey();
    local ll=#str;
    local w=size*ll/2+2*CC.MenuBorderPixel;
	local h=size+2*CC.MenuBorderPixel;
	if x==-1 then
        x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2;
	end
	if y==-1 then
        y=(CC.ScreenH-size-2*CC.MenuBorderPixel)/2;
	end

    DrawStrBox(x,y,str,color,size);
    local menu={{"ȷ��/��",nil,1},
	            {"ȡ��/��",nil,2}};

	local r=ShowMenu(menu,2,0,x+w-4*size-2*CC.MenuBorderPixel,y+h+CC.MenuBorderPixel,0,0,1,0,CC.DefaultFont,C_ORANGE, C_WHITE)

    if r==1 then
	    return true;
	else
	    return false;
	end

end


--��ʾ�ַ������ȴ��������ַ���������ʾ����Ļ�м�
function DrawStrBoxWaitKey(s,color,size)          --��ʾ�ַ������ȴ�����
    lib.GetKey();
    Cls();
    DrawStrBox(-1,-1,s,color,size);
    ShowScreen();
    WaitKey();
end

--���� [0 , i-1] �����������
function Rnd(i)           --�����
    local r=math.random(i);
    return r-1;
end

--�����������ԣ���������ֵ���ƣ���Ӧ�����ֵ���ơ���Сֵ������Ϊ0
--id ����id
--str�����ַ���
--value Ҫ���ӵ�ֵ��������ʾ����
--����1,ʵ�����ӵ�ֵ
--����2���ַ�����xxx ����/���� xxxx��������ʾҩƷЧ��
function AddPersonAttrib(id,str,value)            --������������
    local oldvalue=JY.Person[id][str];
    local attribmax=math.huge;
    if str=="����" then
        attribmax=JY.Person[id]["�������ֵ"] ;
    elseif str=="����" then
        attribmax=JY.Person[id]["�������ֵ"] ;
    else
        if CC.PersonAttribMax[str] ~= nil then
            attribmax=CC.PersonAttribMax[str];
        end
    end
    local newvalue=limitX(oldvalue+value,0,attribmax);
    JY.Person[id][str]=newvalue;
    local add=newvalue-oldvalue;

    local showstr="";
    if add>0 then
        showstr=string.format("%s ���� %d",str,add);
    elseif add<0 then
        showstr=string.format("%s ���� %d",str,-add);
    end
    return add,showstr;
end

--����midi
function PlayMIDI(id)             --����midi
    JY.CurrentMIDI=id;
    if JY.EnableMusic==0 then
        return ;
    end
    if id>=0 then
        lib.PlayMIDI(string.format(CC.MIDIFile,id+1));
    end
end

--������Чatk***
function PlayWavAtk(id)             --������Чatk***
    if JY.EnableSound==0 then
        return ;
    end
    if id>=0 then
        lib.PlayWAV(string.format(CC.ATKFile,id));
    end
end

--������Чe**
function PlayWavE(id)              --������Чe**
    if JY.EnableSound==0 then
        return ;
    end
    if id>=0 then
        lib.PlayWAV(string.format(CC.EFile,id));
    end
end

--flag =0 or nil ȫ��ˢ����Ļ
--      1 ��������εĿ���ˢ��
function ShowScreen(flag)              --ˢ����Ļ��ʾ
    if JY.Darkness==0 then
	    if flag==nil then
		    flag=0;
		end
	    lib.ShowSurface(flag);
    end
end

--ͨ�ò˵�����
-- menuItem ��ÿ���һ���ӱ�����Ϊһ���˵���Ķ���
--          �˵����Ϊ  {   ItemName,     �˵��������ַ���
--                          ItemFunction, �˵����ú��������û����Ϊnil
--                          Visible       �Ƿ�ɼ�  0 ���ɼ� 1 �ɼ�, 2 �ɼ�����Ϊ��ǰѡ���ֻ����һ��Ϊ2��
--                                        ������ֻȡ��һ��Ϊ2�ģ�û�����һ���˵���Ϊ��ǰѡ���
--                                        ��ֻ��ʾ���ֲ˵�������´�ֵ��Ч��
--                                        ��ֵĿǰֻ�����Ƿ�˵�ȱʡ��ʾ������
--                       }
--          �˵����ú���˵����         itemfunction(newmenu,id)
--
--       ����ֵ
--              0 �������أ������˵�ѭ�� 1 ���ú���Ҫ���˳��˵��������в˵�ѭ��
--
-- numItem      �ܲ˵������
-- numShow      ��ʾ�˵���Ŀ������ܲ˵���ܶ࣬һ����ʾ���£�����Զ����ֵ
--                =0��ʾ��ʾȫ���˵���

-- (x1,y1),(x2,y2)  �˵���������ϽǺ����½����꣬���x2,y2=0,������ַ������Ⱥ���ʾ�˵����Զ�����x2,y2
-- isBox        �Ƿ���Ʊ߿�0 �����ƣ�1 ���ơ������ƣ�����(x1,y1,x2,y2)�ľ��λ��ư�ɫ���򣬲�ʹ�����ڱ����䰵
-- isEsc        Esc���Ƿ������� 0 �������ã�1������
-- Size         �˵��������С
-- color        �����˵�����ɫ����ΪRGB
-- selectColor  ѡ�в˵�����ɫ,
--;
-- ����ֵ  0 Esc����
--         >0 ѡ�еĲ˵���(1��ʾ��һ��)
--         <0 ѡ�еĲ˵�����ú���Ҫ���˳����˵�����������˳����˵�

function ShowMenu(menuItem,numItem,numShow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor)     --ͨ�ò˵�����
    lib.Debug(string.format("ShowMenu"));
    local w=0;
    local h=0;   --�߿�Ŀ��
    local i=0;
    local num=0;     --ʵ�ʵ���ʾ�˵���
    local newNumItem=0;  --�ܹ���ʾ���ܲ˵�����

    lib.GetKey();

    local newMenu={};   -- �����µ����飬�Ա�����������ʾ�Ĳ˵���

    --�����ܹ���ʾ���ܲ˵�����
    for i=1,numItem do
        if menuItem[i][3]>0 then
            newNumItem=newNumItem+1;
            newMenu[newNumItem]={menuItem[i][1],menuItem[i][2],menuItem[i][3],i};   --���������[4],�����ԭ����Ķ�Ӧ
        end
    end

    --����ʵ����ʾ�Ĳ˵�����
    if numShow==0 or numShow > newNumItem then
        num=newNumItem;
    else
        num=numShow;
    end

    --����߿�ʵ�ʿ��
    local maxlength=0;
    if x2==0 and y2==0 then
        for i=1,newNumItem do
            if string.len(newMenu[i][1])>maxlength then
                maxlength=string.len(newMenu[i][1]);
            end
        end
        w=size*maxlength/2+2*CC.MenuBorderPixel;        --���հ�����ּ����ȣ�һ����4������
        h=(size+CC.RowPixel)*num+CC.MenuBorderPixel;            --��֮����4�����أ���������4������
    else
        w=x2-x1;
        h=y2-y1;
    end

    local start=1;             --��ʾ�ĵ�һ��

	local current =1;          --��ǰѡ����
	for i=1,newNumItem do
	    if newMenu[i][3]==2 then
		    current=i;
			break;
		end
	end
	if numShow~=0 then
	    current=1;
	end

    local keyPress =-1;
    local returnValue =0;
	if isBox==1 then
		DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
	end

    while true do
	    if numShow ~=0 then
	        Cls(x1,y1,x1+w,y1+h);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		end

	    for i=start,start+num-1 do
  	        local drawColor=color;           --���ò�ͬ�Ļ�����ɫ
	        if i==current then
	            drawColor=selectColor;
	        end
			DrawString(x1+CC.MenuBorderPixel,y1+CC.MenuBorderPixel+(i-start)*(size+CC.RowPixel),
			           newMenu[i][1],drawColor,size);

	    end
	    ShowScreen();
		keyPress=WaitKey();
		lib.Delay(100);
		-- lib.Debug(string.format("keypress %d", keyPress));
		if keyPress==VK_ESCAPE then                  --Esc �˳�
		    if isEsc==1 then
		        break;
		    end
		elseif keyPress==VK_DOWN then                --Down
		    current = current +1;
		    if current > (start + num-1) then
		        start=start+1;
		    end
		    if current > newNumItem then
		        start=1;
		        current =1;
		    end
		elseif keyPress==VK_UP then                  --Up
		    current = current -1;
		    if current < start then
		        start=start-1;
		    end
		    if current < 1 then
		        current = newNumItem;
		        start =current-num+1;
		    end
		elseif   (keyPress==VK_SPACE) or (keyPress==VK_RETURN)  then
		    if newMenu[current][2]==nil then
		        returnValue=newMenu[current][4];
		        break;
		    else
		        local r=newMenu[current][2](newMenu,current);               --���ò˵�����
		        if r==1 then
		            returnValue= -newMenu[current][4];
		            break;
				else
			        Cls(x1,y1,x1+w,y1+h);
					if isBox==1 then
						DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
					end
		        end
		    end
		end
    end

    Cls(x1,y1,x1+w+1,y1+h+1,0,1);

    return returnValue;
end

--������ʾ�˵���������ShowMenuһ��
function ShowMenu2(menuItem,numItem,numShow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor)     --ͨ�ò˵�����
    lib.Debug(string.format("ShowMenu2"));
    local w=0;
    local h=0;   --�߿�Ŀ��
    local i=0;
    local num=0;     --ʵ�ʵ���ʾ�˵���
    local newNumItem=0;  --�ܹ���ʾ���ܲ˵�����

    lib.GetKey();

    local newMenu={};   -- �����µ����飬�Ա�����������ʾ�Ĳ˵���

    --�����ܹ���ʾ���ܲ˵�����
    for i=1,numItem do
        if menuItem[i][3]>0 then
            newNumItem=newNumItem+1;
            newMenu[newNumItem]={menuItem[i][1],menuItem[i][2],menuItem[i][3],i};   --���������[4],�����ԭ����Ķ�Ӧ
        end
    end

    --����ʵ����ʾ�Ĳ˵�����
    if numShow==0 or numShow > newNumItem then
        num=newNumItem;
    else
        num=numShow;
    end

    --����߿�ʵ�ʿ��
    local maxlength=0;
    if x2==0 and y2==0 then
        for i=1,newNumItem do
            if string.len(newMenu[i][1])>maxlength then
                maxlength=string.len(newMenu[i][1]);
            end
        end
		w=(size*maxlength/2+CC.RowPixel)*num+CC.MenuBorderPixel;
		h=size+2*CC.MenuBorderPixel;
    else
        w=x2-x1;
        h=y2-y1;
    end

    local start=1;             --��ʾ�ĵ�һ��

    local current =1;          --��ǰѡ����
	for i=1,newNumItem do
	    if newMenu[i][3]==2 then
		    current=i;
			break;
		end
	end
	if numShow~=0 then
	    current=1;
	end

    local keyPress =-1;
    local returnValue =0;
	if isBox==1 then
		DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
	end
    while true do
	    if numShow ~=0 then
	        Cls(x1,y1,x1+w,y1+h);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		end

	    for i=start,start+num-1 do
  	        local drawColor=color;           --���ò�ͬ�Ļ�����ɫ
	        if i==current then
	            drawColor=selectColor;
	        end
			DrawString(x1+CC.MenuBorderPixel+(i-start)*(size*maxlength/2+CC.RowPixel),
			           y1+CC.MenuBorderPixel,newMenu[i][1],drawColor,size);
	    end
	    ShowScreen();
		keyPress=WaitKey();
		lib.Delay(100);

		if keyPress==VK_ESCAPE then                  --Esc �˳�
		    if isEsc==1 then
		        break;
		    end
		elseif keyPress==VK_RIGHT then                --Down
		    current = current +1;
		    if current > (start + num-1) then
		        start=start+1;
		    end
		    if current > newNumItem then
		        start=1;
		        current =1;
		    end
		elseif keyPress==VK_LEFT then                  --Up
		    current = current -1;
		    if current < start then
		        start=start-1;
		    end
		    if current < 1 then
		        current = newNumItem;
		        start =current-num+1;
		    end
		elseif   (keyPress==VK_SPACE) or (keyPress==VK_RETURN)  then
		    if newMenu[current][2]==nil then
		        returnValue=newMenu[current][4];
		        break;
		    else
		        local r=newMenu[current][2](newMenu,current);               --���ò˵�����
		        if r==1 then
		            returnValue= -newMenu[current][4];
		            break;
				else
			        Cls(x1,y1,x1+w,y1+h);
					if isBox==1 then
						DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
					end
		        end
		    end
		end
    end

    Cls(x1,y1,x1+w+1,y1+h+1,0,1);
    return returnValue;
end

------------------------------------------------------------------------------------
--------------------------------------��Ʒʹ��---------------------------------------
--��Ʒʹ��ģ��
--��ǰ��Ʒid
--����1 ʹ������Ʒ�� 0 û��ʹ����Ʒ��������ĳЩԭ����ʹ��
function UseThing(id)             --��Ʒʹ��
    --���ú���
	if JY.ThingUseFunction[id]==nil then
	    return DefaultUseThing(id);
	else
        return JY.ThingUseFunction[id](id);
    end
end

--ȱʡ��Ʒʹ�ú�����ʵ��ԭʼ��ϷЧ��
--id ��Ʒid
function DefaultUseThing(id)                --ȱʡ��Ʒʹ�ú���
    if JY.Thing[id]["����"]==0 then
        return UseThing_Type0(id);
    elseif JY.Thing[id]["����"]==1 then
        return UseThing_Type1(id);
    elseif JY.Thing[id]["����"]==2 then
        return UseThing_Type2(id);
    elseif JY.Thing[id]["����"]==3 then
        return UseThing_Type3(id);
    elseif JY.Thing[id]["����"]==4 then
        return UseThing_Type4(id);
    end
end

--������Ʒ�������¼�
function UseThing_Type0(id)              --������Ʒʹ��
    if JY.SubScene>=0 then
		local x=JY.Base["��X1"]+CC.DirectX[JY.Base["�˷���"]+1];
		local y=JY.Base["��Y1"]+CC.DirectY[JY.Base["�˷���"]+1];
        local d_num=GetS(JY.SubScene,x,y,3)
        if d_num>=0 then
            JY.CurrentThing=id;
            EventExecute(d_num,2);       --��Ʒ�����¼�
            JY.CurrentThing=-1;
			return 1;
		else
		    return 0;
        end
    end
end

--װ����Ʒ
function UseThing_Type1(id)            --װ����Ʒʹ��
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,string.format("˭Ҫ�䱸%s?",JY.Thing[id]["����"]),C_WHITE,CC.DefaultFont);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
    local r=SelectTeamMenu(CC.MainSubMenuX,nexty);

    if r>0 then
        local personid=JY.Base["����" ..r]
        if CanUseThing(id,personid) then
            if JY.Thing[id]["װ������"]==0 then
                if JY.Thing[id]["ʹ����"]>=0 then
                    JY.Person[JY.Thing[id]["ʹ����"]]["����"]=-1;
                end
                if JY.Person[personid]["����"]>=0 then
                    JY.Thing[JY.Person[personid]["����"]]["ʹ����"]=-1
                end
                JY.Person[personid]["����"]=id;
            elseif JY.Thing[id]["װ������"]==1 then
                if JY.Thing[id]["ʹ����"]>=0 then
                    JY.Person[JY.Thing[id]["ʹ����"]]["����"]=-1;
                end
                if JY.Person[personid]["����"]>=0 then
                    JY.Thing[JY.Person[personid]["����"]]["ʹ����"]=-1
                end
                JY.Person[personid]["����"]=id;
            end
            JY.Thing[id]["ʹ����"]=personid
        else
            DrawStrBoxWaitKey("���˲��ʺ��䱸����Ʒ",C_WHITE,CC.DefaultFont);
			return 0;
        end
    end
--    Cls();
--    ShowScreen();
	return 1;
end

--�ж�һ�����Ƿ����װ��������һ����Ʒ
--���� true����������false����
function CanUseThing(id,personid)           --�ж�һ�����Ƿ����װ��������һ����Ʒ
    local str="";
    if JY.Thing[id]["����������"] >=0 then
        if JY.Thing[id]["����������"] ~= personid then
            return false;
        end
    end

    if JY.Thing[id]["����������"] ~=2 and JY.Person[personid]["��������"] ~=2 then
        if JY.Thing[id]["����������"] ~= JY.Person[personid]["��������"] then
            return false;
        end
    end

    if JY.Thing[id]["������"] > JY.Person[personid]["�������ֵ"] then
        return false;
    end
    if JY.Thing[id]["�蹥����"] > JY.Person[personid]["������"] then
        return false;
    end
    if JY.Thing[id]["���Ṧ"] > JY.Person[personid]["�Ṧ"] then
        return false;
    end
    if JY.Thing[id]["���ö�����"] > JY.Person[personid]["�ö�����"] then
        return false;
    end
    if JY.Thing[id]["��ҽ������"] > JY.Person[personid]["ҽ������"] then
        return false;
    end
    if JY.Thing[id]["��ⶾ����"] > JY.Person[personid]["�ⶾ����"] then
        return false;
    end
    if JY.Thing[id]["��ȭ�ƹ���"] > JY.Person[personid]["ȭ�ƹ���"] then
        return false;
    end
    if JY.Thing[id]["����������"] > JY.Person[personid]["��������"] then
        return false;
    end
    if JY.Thing[id]["��ˣ������"] > JY.Person[personid]["ˣ������"] then
        return false;
    end
    if JY.Thing[id]["���������"] > JY.Person[personid]["�������"] then
        return false;
    end
    if JY.Thing[id]["�谵������"] > JY.Person[personid]["��������"] then
        return false;
    end
    if JY.Thing[id]["������"] >= 0 then
        if JY.Thing[id]["������"] > JY.Person[personid]["����"] then
            return false;
        end
    else
        if -JY.Thing[id]["������"] < JY.Person[personid]["����"] then
            return false;
        end
    end

    return true
end


--�ؼ���Ʒ
function UseThing_Type2(id)               --�ؼ���Ʒʹ��
    if JY.Thing[id]["ʹ����"]>=0 then
        if DrawStrBoxYesNo(-1,-1,"����Ʒ�Ѿ������������Ƿ�������?",C_WHITE,CC.DefaultFont)==false then
            Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
            ShowScreen();
            return 0;
        end
    end

    Cls();
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,string.format("˭Ҫ����%s?",JY.Thing[id]["����"]),C_WHITE,CC.DefaultFont);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
    local r=SelectTeamMenu(CC.MainSubMenuX,nexty);

    if r>0 then
        local personid=JY.Base["����" ..r]

        if JY.Thing[id]["�����书"]>=0 then
            local yes=0;
            for i = 1,10 do
                if JY.Person[personid]["�书"..i]==JY.Thing[id]["�����书"] then
                    yes=1;             --�书�Ѿ�����
                    break;
                end
            end
            if yes==0 and JY.Person[personid]["�书10"]>0 then
                DrawStrBoxWaitKey("һ����ֻ������10���书",C_WHITE,CC.DefaultFont);
                return 0;
            end
        end

       if CC.Shemale[id]==1 then                --��а�Ϳ���
		    if JY.Person[personid]["�Ա�"]==0 then
				Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
				if DrawStrBoxYesNo(-1,-1,"������������Ȼӵ��Թ����Ƿ���Ҫ����?",C_WHITE,CC.DefaultFont)==false then
					return 0;
				else
					JY.Person[personid]["�Ա�"]=2;
				end
			elseif JY.Person[personid]["�Ա�"]==1 then
				DrawStrBoxWaitKey("���˲��ʺ���������Ʒ",C_WHITE,CC.DefaultFont);
				return 0;
			end
        end


        if CanUseThing(id,personid) then
            if JY.Thing[id]["ʹ����"]==personid then
                return 0;
            end

            if JY.Person[personid]["������Ʒ"]>=0 then
                JY.Thing[JY.Person[personid]["������Ʒ"]]["ʹ����"]=-1;
            end

            if JY.Thing[id]["ʹ����"]>=0 then
                JY.Person[JY.Thing[id]["ʹ����"]]["������Ʒ"]=-1;
                JY.Person[JY.Thing[id]["ʹ����"]]["��������"]=0;
                JY.Person[JY.Thing[id]["ʹ����"]]["��Ʒ��������"]=0;
            end

            JY.Thing[id]["ʹ����"]=personid
            JY.Person[personid]["������Ʒ"]=id;
            JY.Person[personid]["��������"]=0;
            JY.Person[personid]["��Ʒ��������"]=0;
        else
            DrawStrBoxWaitKey("���˲��ʺ���������Ʒ",C_WHITE,CC.DefaultFont);
			return 0;
        end
    end

	return 1;
end

--ҩƷ��Ʒ
function UseThing_Type3(id)        --ҩƷ��Ʒʹ��
    local usepersonid=-1;
    if JY.Status==GAME_MMAP or JY.Status==GAME_SMAP then
        Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
        DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,string.format("˭Ҫʹ��%s?",JY.Thing[id]["����"]),C_WHITE,CC.DefaultFont);
	    local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
        local r=SelectTeamMenu(CC.MainSubMenuX,nexty);
        if r>0 then
            usepersonid=JY.Base["����" ..r]
        end
    elseif JY.Status==GAME_WMAP then           ---ս������ʹ��ҩƷ
        usepersonid=WAR.Person[WAR.CurID]["������"];
    end

    if usepersonid>=0 then
        if UseThingEffect(id,usepersonid)==1 then       --ʹ����Ч��
            instruct_32(id,-1);            --��Ʒ��������
            WaitKey();
        else
            return 0;
        end
    end

 --   Cls();
 --   ShowScreen();
	return 1;
end

--ҩƷʹ��ʵ��Ч��
--id ��Ʒid��
--personid ʹ����id
--����ֵ��0 ʹ��û��Ч������Ʒ����Ӧ�ò��䡣1 ʹ����Ч������ʹ�ú���Ʒ����Ӧ��-1
function UseThingEffect(id,personid)          --ҩƷʹ��ʵ��Ч��
    local str={};
    str[0]=string.format("ʹ�� %s",JY.Thing[id]["����"]);
    local strnum=1;
    local addvalue;

    if JY.Thing[id]["������"] >0 then
        local add=JY.Thing[id]["������"]-math.modf(JY.Person[personid]["���˳̶�"]/2)+Rnd(10);
        if add <=0 then
            add=5+Rnd(5);
        end
        AddPersonAttrib(personid,"���˳̶�",-JY.Thing[id]["������"]/4);
        addvalue,str[strnum]=AddPersonAttrib(personid,"����",add);
        if addvalue ~=0 then
            strnum=strnum+1
        end
    end

    local function ThingAddAttrib(s)     ---����ֲ������������ҩ����������
        if JY.Thing[id]["��" .. s] ~=0 then
            addvalue,str[strnum]=AddPersonAttrib(personid,s,JY.Thing[id]["��" .. s]);
            if addvalue ~=0 then
                strnum=strnum+1
            end
        end
    end

    ThingAddAttrib("�������ֵ");

    if JY.Thing[id]["���ж��ⶾ"] <0 then
        addvalue,str[strnum]=AddPersonAttrib(personid,"�ж��̶�",math.modf(JY.Thing[id]["���ж��ⶾ"]/2));
        if addvalue ~=0 then
            strnum=strnum+1
        end
    end

    ThingAddAttrib("����");

    if JY.Thing[id]["�ı���������"] ==2 then
        str[strnum]="������·��Ϊ������һ"
        strnum=strnum+1
    end

    ThingAddAttrib("����");
    ThingAddAttrib("�������ֵ");
    ThingAddAttrib("������");
    ThingAddAttrib("������");
    ThingAddAttrib("�Ṧ");
    ThingAddAttrib("ҽ������");
    ThingAddAttrib("�ö�����");
    ThingAddAttrib("�ⶾ����");
    ThingAddAttrib("��������");
    ThingAddAttrib("ȭ�ƹ���");
    ThingAddAttrib("��������");
    ThingAddAttrib("ˣ������");
    ThingAddAttrib("�������");
    ThingAddAttrib("��������");
    ThingAddAttrib("��ѧ��ʶ");
    ThingAddAttrib("��������");

    if strnum>1 then
        local maxlength=0      --�����ַ�����󳤶�
        for i = 0,strnum-1 do
            if #str[i] > maxlength then
                maxlength=#str[i];
            end
        end
        Cls();

		local ww=maxlength*CC.DefaultFont/2+CC.MenuBorderPixel*2;
		local hh=strnum*CC.DefaultFont+(strnum-1)*CC.RowPixel+2*CC.MenuBorderPixel;
        local x=(CC.ScreenW-ww)/2;
		local y=(CC.ScreenH-hh)/2;
		DrawBox(x,y,x+ww,y+hh,C_WHITE);
        DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel,str[0],C_WHITE,CC.DefaultFont);
        for i =1,strnum-1 do
            DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel+(CC.DefaultFont+CC.RowPixel)*i,str[i],C_ORANGE,CC.DefaultFont);
        end
        ShowScreen();
        return 1;
    else
        return 0;
    end

end


--������Ʒ
function UseThing_Type4(id)             --������Ʒʹ��
    if JY.Status==GAME_WMAP then
         return War_UseAnqi(id);
    end
	return 0;
end



--------------------------------------------------------------------------------
--------------------------------------�¼�����-----------------------------------

--�¼����������
--id��d*�еı��
--flag 1 �ո񴥷���2����Ʒ������3��·������
function EventExecute(id,flag)               --�¼����������
    JY.CurrentD=id;
    if JY.SceneNewEventFunction[JY.SubScene]==nil then         --û�ж����µ��¼������������þɵ�
        oldEventExecute(flag)
	else
        JY.SceneNewEventFunction[JY.SubScene](flag)         --�����µ��¼�������
    end
    JY.CurrentD=-1;
	JY.Darkness=0;
end

--����ԭ�е�ָ��λ�õĺ���
--�ɵĺ������ָ�ʽΪ  oldevent_xxx();  xxxΪ�¼����
function oldEventExecute(flag)            --����ԭ�е�ָ��λ�õĺ���

	local eventnum;
	if flag==1 then
		eventnum=GetD(JY.SubScene,JY.CurrentD,2);
	elseif flag==2 then
		eventnum=GetD(JY.SubScene,JY.CurrentD,3);
	elseif flag==3 then
		eventnum=GetD(JY.SubScene,JY.CurrentD,4);
	end

	if eventnum>0 then
	    oldCallEvent(eventnum);
	end

end

function oldCallEvent(eventnum)     --ִ�оɵ��¼�����
	local eventfilename=string.format("oldevent_%d.lua",eventnum);
	lib.Debug(eventfilename);
	dofile(CONFIG.OldEventPath .. eventfilename);
end


--�ı���ͼ���꣬�ӳ�����ȥ���ƶ�����Ӧ����
function ChangeMMap(x,y,direct)          --�ı���ͼ����
	JY.Base["��X"]=x;
	JY.Base["��Y"]=y;
	JY.Base["�˷���"]=direct;
end

--�ı䵱ǰ����
function ChangeSMap(sceneid,x,y,direct)       --�ı䵱ǰ����
    JY.SubScene=sceneid;
	JY.Base["��X1"]=x;
	JY.Base["��Y1"]=y;
	JY.Base["�˷���"]=direct;
end


--���(x1,y1)-(x2,y2)�����ڵ����ֵȡ�
--���û�в����������������Ļ����
--ע��ú�������ֱ��ˢ����ʾ��Ļ
function Cls(x1,y1,x2,y2)                    --�����Ļ
    if x1==nil then        --��һ������Ϊnil,��ʾû�в�������ȱʡ
	    x1=0;
		y1=0;
		x2=0;
		y2=0;
	end

	lib.SetClip(x1,y1,x2,y2);

	if JY.Status==GAME_START then
	    lib.FillColor(0,0,0,0,0);
        lib.LoadPicture(CC.FirstFile,-1,-1);
	elseif JY.Status==GAME_MMAP then
        lib.DrawMMap(JY.Base["��X"],JY.Base["��Y"],GetMyPic());             --��ʾ����ͼ
	elseif JY.Status==GAME_SMAP then
        DrawSMap();
	elseif JY.Status==GAME_WMAP then
        WarDrawMap(0);
	elseif JY.Status==GAME_DEAD then
	    lib.FillColor(0,0,0,0,0);
        lib.LoadPicture(CC.DeadFile,-1,-1);
	end
	lib.SetClip(0,0,0,0);
end


--�����Ի���ʾ��Ҫ���ַ�������ÿ��n�������ַ���һ���Ǻ�
function GenTalkString(str,n)              --�����Ի���ʾ��Ҫ���ַ���
    local tmpstr="";
    for s in string.gmatch(str .. "*","(.-)%*") do           --ȥ���Ի��е�����*. �ַ���β����һ���Ǻţ������޷�ƥ��
        tmpstr=tmpstr .. s;
    end

    local newstr="";
    while #tmpstr>0 do
		local w=0;
		while w<#tmpstr do
		    local v=string.byte(tmpstr,w+1);          --��ǰ�ַ���ֵ
			if v>=128 then
			    w=w+2;
			else
			    w=w+1;
			end
			if w >= 2*n-1 then     --Ϊ�˱����������ַ�
			    break;
			end
		end

        if w<#tmpstr then
		    if w==2*n-1 and string.byte(tmpstr,w+1)<128 then
				newstr=newstr .. string.sub(tmpstr,1,w+1) .. "*";
				tmpstr=string.sub(tmpstr,w+2,-1);
			else
				newstr=newstr .. string.sub(tmpstr,1,w)  .. "*";
				tmpstr=string.sub(tmpstr,w+1,-1);
			end
		else
		    newstr=newstr .. tmpstr;
			break;
		end
	end
    return newstr;
end

--��򵥰汾�Ի�
function Talk(s,personid)            --��򵥰汾�Ի�
    local flag;
    if personid==0 then
        flag=1;
	else
	    flag=0;
	end
	TalkEx(s,JY.Person[personid]["ͷ�����"],flag);
end


--���Ӱ汾�Ի�
--s �ַ������������*��Ϊ���У��������û��*,����Զ�����
function TalkEx(s,headid,flag)          --���Ӱ汾�Ի�
    local picw=100;       --���ͷ��ͼƬ���
	local pich=100;
	local talkxnum=12;         --�Ի�һ������
	local talkynum=3;          --�Ի�����
	local dx=2;
	local dy=2;
    local boxpicw=picw+10;
	local boxpich=pich+10;
	local boxtalkw=12*CC.DefaultFont+10;
	local boxtalkh=boxpich;

    local talkBorder=(pich-talkynum*CC.DefaultFont)/(talkynum+1);

	--��ʾͷ��ͶԻ�������
    local xy={ [0]={headx=dx,heady=dy,
	                talkx=dx+boxpicw+2,talky=dy,
					showhead=1},
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				    talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich,
					showhead=1},
                   {headx=dx,heady=dy,
				   talkx=dx+boxpicw+2,talky=dy,
				   showhead=0},
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				   talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich,
					showhead=1},
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=dy,
				    talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky=dy,showhead=1},
                   {headx=dx,heady=CC.ScreenH-dy-boxpich,talkx=dx+boxpicw+2,talky=CC.ScreenH-dy-boxpich,showhead=1}, }

    if flag<0 or flag>5 then
        flag=0;
    end

    if xy[flag].showhead==0 then
        headid=-1;
    end

	if string.find(s,"*") ==nil then
	    s=GenTalkString(s,12);
	end

    if CONFIG.KeyRepeat==0 then
	     lib.EnableKeyRepeat(0,CONFIG.KeyRepeatInterval);
	end
    lib.GetKey();

    local startp=1
    local endp;
    local dy=0;
    while true do
        if dy==0 then
		    Cls();
            if headid>=0 then
                DrawBox(xy[flag].headx, xy[flag].heady, xy[flag].headx + boxpicw, xy[flag].heady + boxpich,C_WHITE);
				local w,h=lib.PicGetXY(1,headid*2);
                local x=(picw-w)/2;
				local y=(pich-h)/2;
				lib.PicLoadCache(1,headid*2,xy[flag].headx+5+x,xy[flag].heady+5+y,1);
            end
            DrawBox(xy[flag].talkx, xy[flag].talky, xy[flag].talkx +boxtalkw, xy[flag].talky + boxtalkh,C_WHITE);
        end
        endp=string.find(s,"*",startp);
        if endp==nil then
            DrawString(xy[flag].talkx + 5, xy[flag].talky + 5+talkBorder + dy * (CC.DefaultFont+talkBorder),string.sub(s,startp),C_WHITE,CC.DefaultFont);
            ShowScreen();
            WaitKey();
            break;
        else
            DrawString(xy[flag].talkx + 5, xy[flag].talky + 5+talkBorder + dy * (CC.DefaultFont+talkBorder),string.sub(s,startp,endp-1),C_WHITE,CC.DefaultFont);
        end
        dy=dy+1;
        startp=endp+1;
        if dy>=talkynum then
            ShowScreen();
            WaitKey();
            dy=0;
        end
    end

    if CONFIG.KeyRepeat==0 then
	     lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRepeatInterval);
	end

	Cls();
end

--����ָ�ռλ����
function instruct_test(s)
    DrawStrBoxWaitKey(s,C_ORANGE,24);
end

--����
function instruct_0()         --����
    Cls();
end

--�Ի�
--talkid: Ϊ���֣���Ϊ�Ի���ţ�Ϊ�ַ�������Ϊ�Ի�����
--headid: ͷ��id
--flag :�Ի���λ�ã�0 ��Ļ�Ϸ���ʾ, ���ͷ���ұ߶Ի�
--            1 ��Ļ�·���ʾ, ��߶Ի����ұ�ͷ��
--            2 ��Ļ�Ϸ���ʾ, ��߿գ��ұ߶Ի�
--            3 ��Ļ�·���ʾ, ��߶Ի����ұ߿�
--            4 ��Ļ�Ϸ���ʾ, ��߶Ի����ұ�ͷ��
--            5 ��Ļ�·���ʾ, ���ͷ���ұ߶Ի�

function instruct_1(talkid,headid,flag)        --�Ի�
    local s=ReadTalk(talkid);
	if s==nil then        --�Ի�id������
	    return ;
	end
    TalkEx(s,headid,flag);
end

--����oldtalk.grp�ļ���idx�����ļ�����������Ի�ʹ��
function GenTalkIdx()         --���ɶԻ������ļ�
	os.remove(CC.TalkIdxFile);
	local p=io.open(CC.TalkIdxFile,"w");
	p:close();

	p=io.open(CC.TalkGrpFile,"r");
	local num=0
	for line in p:lines() do
	    num=num+1;
	end
    p:seek("set",0);
	local data=Byte.create(num*4);

	for i=0,num-1 do
	    local talk=p:read("*line");
		local offset=p:seek();
		Byte.set32(data,i*4,offset);
	end
    p:close();

	Byte.savefile(data,CC.TalkIdxFile,0,num*4);
end

--��old_talk.lua�ж�ȡ���Ϊtalkid���ַ�����
--��Ҫ��ʱ���ȡ�����Խ�Լ�ڴ�ռ�ã������ٰ������ļ������ڴ������ˡ�
function ReadTalk(talkid)            --���ļ���ȡһ���Ի�
	local idxfile=CC.TalkIdxFile
    local grpfile=CC.TalkGrpFile

	local length=filelength(idxfile);

	if talkid<0 and talkid>=length/4 then
	    return
	end

	local data=Byte.create(2*4);
	local id1,id2;
	if talkid==0 then
        Byte.loadfile(data,idxfile,0,4);
		id1=0;
	    id2=Byte.get32(data,0);
    else
        Byte.loadfile(data,idxfile,(talkid-1)*4,4*2);
		id1=Byte.get32(data,0);
	    id2=Byte.get32(data,4);
    end

    local p=io.open(grpfile,"r");
    p:seek("set",id1);
	local talk=p:read("*line");
	p:close();

	return talk;

end


--�õ���Ʒ
function instruct_2(thingid,num)            --�õ���Ʒ
    if JY.Thing[thingid]==nil then   --�޴���Ʒid
        return ;
	end

    instruct_32(thingid,num);    --������Ʒ
    DrawStrBoxWaitKey(string.format("�õ���Ʒ:%s %d",JY.Thing[thingid]["����"],num),C_ORANGE,CC.DefaultFont);
    instruct_2_sub();         --�Ƿ�ɵ�������
end

--����>200�Լ�14�����õ�������
function instruct_2_sub()               --����>200�Լ�14�����õ�������

    if JY.Person[0]["����"] < 200 then
        return ;
    end

    if instruct_18(189) ==true then            --���������� 189 ������id
        return;
    end

    local booknum=0;
    for i=1,CC.BookNum do
        if instruct_18(CC.BookStart+i-1)==true then
            booknum=booknum+1;
        end
    end

    if booknum==CC.BookNum then        --�������Ǿ������ϵ��������¼�
        instruct_3(70,11,-1,1,932,-1,-1,7968,7968,7968,-2,-2,-2);
    end
end

--�޸�D*
-- sceneid ����id, -2��ʾ��ǰ����
-- id  D*��id�� -2��ʾ��ǰid
-- v0 - v10 D*������ -2��ʾ�˲�������
function instruct_3(sceneid,id,v0,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10)     --�޸�D*
    if sceneid==-2 then
        sceneid=JY.SubScene;
    end
    if id==-2 then
        id=JY.CurrentD;
    end

    if v0~=-2 then
        SetD(sceneid,id,0,v0)
    end
    if v1~=-2 then
        SetD(sceneid,id,1,v1)
    end
    if v2~=-2 then
        SetD(sceneid,id,2,v2)
    end
    if v3~=-2 then
        SetD(sceneid,id,3,v3)
    end
    if v4~=-2 then
        SetD(sceneid,id,4,v4)
    end
    if v5~=-2 then
        SetD(sceneid,id,5,v5)
    end
    if v6~=-2 then
        SetD(sceneid,id,6,v6)
    end
    if v7~=-2 then
        SetD(sceneid,id,7,v7)
    end
    if v8~=-2 then
        SetD(sceneid,id,8,v8)
    end

    if v9~=-2 and v10 ~=-2 then
	    if v9>0 and v10 >0 then   --Ϊ�˺Ͳ������ݣ��޸ĵ����겻��Ϊ0
            SetS(sceneid,GetD(sceneid,id,9),GetD(sceneid,id,10),3,-1);   --���xy�����ƶ��ˣ���ôS����Ӧ����Ҫ�޸ġ�
            SetD(sceneid,id,9,v9)
            SetD(sceneid,id,10,v10)
            SetS(sceneid,GetD(sceneid,id,9),GetD(sceneid,id,10),3,id);
		end
	end
end

--�Ƿ�ʹ����Ʒ����
function instruct_4(thingid)         --�Ƿ�ʹ����Ʒ����
    if JY.CurrentThing==thingid then
        return true;
    else
        return false;
    end
end


function instruct_5()         --ѡ��ս��
    return DrawStrBoxYesNo(-1,-1,"�Ƿ���֮����(Y/N)?",C_ORANGE,CC.DefaultFont);
end


function instruct_6(warid,tmp,tmp,flag)      --ս��
    return WarMain(warid,flag);
end


function instruct_7()                 --�Ѿ�����Ϊreturn��
    instruct_test("ָ��7����")
end


function instruct_8(musicid)            --�ı�����ͼ����
    JY.MmapMusic=musicid;
end


function instruct_9()                --�Ƿ�Ҫ��������
    Cls();
    return DrawStrBoxYesNo(-1,-1,"�Ƿ�Ҫ�����(Y/N)?",C_ORANGE,CC.DefaultFont);
end


function instruct_10(personid)            --�����Ա
    if JY.Person[personid]==nil then
        lib.Debug("instruct_10 error: person id not exist");
		return ;
    end
    local add=0;
    for i =2, CC.TeamNum do             --��һ��λ�������ǣ��ӵڶ�����ʼ
        if JY.Base["����"..i]<0 then
            JY.Base["����"..i]=personid;
            add=1;
            break;
        end
    end
    if add==0 then
        lib.Debug("instruct_10 error: �����������");
        return ;
    end

    for i =1,4 do                --������Ʒ�鹫
        local id =JY.Person[personid]["Я����Ʒ" .. i];
        local n=JY.Person[personid]["Я����Ʒ����" .. i];
        if id>=0 and n>0 then
            instruct_2(id,n);
            JY.Person[personid]["Я����Ʒ" .. i]=-1;
            JY.Person[personid]["Я����Ʒ����" .. i]=0;
        end
    end
end


function instruct_11()              --�Ƿ�ס��
    Cls();
    return DrawStrBoxYesNo(-1,-1,"�Ƿ�ס��(Y/N)?",C_ORANGE,CC.DefaultFont);
end


function instruct_12()             --ס�ޣ��ظ�����
    for i=1,CC.TeamNum do
        local id=JY.Base["����" .. i];
        if id>=0 then
            if JY.Person[id]["���˳̶�"]<33 and JY.Person[id]["�ж��̶�"]<=0 then
                JY.Person[id]["���˳̶�"]=0;
                AddPersonAttrib(id,"����",math.huge);     --��һ���ܴ��ֵ���Զ�����Ϊ���ֵ
                AddPersonAttrib(id,"����",math.huge);
                AddPersonAttrib(id,"����",math.huge);
            end
        end
    end
end


function instruct_13()            --��������
    Cls();
    JY.Darkness=0;
    lib.ShowSlow(50,0)
	lib.GetKey();
end


function instruct_14()             --�������
    lib.ShowSlow(50,1);
    JY.Darkness=1;
end

function instruct_15()          --game over
    JY.Status=GAME_DEAD;
    Cls();
    DrawString(CC.GameOverX,CC.GameOverY,JY.Person[0]["����"],RGB(0,0,0),CC.DefaultFont);

	local x=CC.ScreenW-9*CC.DefaultFont;
    DrawString(x,10,os.date("%Y-%m-%d %H:%M"),RGB(216, 20, 24) ,CC.DefaultFont);
    DrawString(x,10+CC.DefaultFont+CC.RowPixel,"�ڵ����ĳ��",RGB(216, 20, 24) ,CC.DefaultFont);
    DrawString(x,10+(CC.DefaultFont+CC.RowPixel)*2,"�����˿ڵ�ʧ����",RGB(216, 20, 24) ,CC.DefaultFont);
    DrawString(x,10+(CC.DefaultFont+CC.RowPixel)*3,"�ֶ���һ�ʡ�����",RGB(216, 20, 24) ,CC.DefaultFont);

    local loadMenu={ {"�������һ",nil,1},
                     {"������ȶ�",nil,1},
                     {"���������",nil,1},
                     {"�ؼ�˯��ȥ",nil,1} };
    local y=CC.ScreenH-4*(CC.DefaultFont+CC.RowPixel)-10;
    local r=ShowMenu(loadMenu,4,0,x,y,0,0,0,0,CC.DefaultFont,C_ORANGE, C_WHITE)

    if r<4 then
        LoadRecord(r);
        JY.Status=GAME_FIRSTMMAP;
    else
        JY.Status=GAME_END;
    end

end


function instruct_16(personid)      --�������Ƿ���ĳ��
    local r=false;
    for i = 1, CC.TeamNum do
        if personid==JY.Base["����" .. i] then
            r=true;
            break;
        end
    end;
    return r;
end


function instruct_17(sceneid,level,x,y,v)     --�޸ĳ���ͼ��
    if sceneid==-2 then
        sceneid=JY.SubScene;
    end
    SetS(sceneid,x,y,level,v);
end


function instruct_18(thingid)           --�Ƿ���ĳ����Ʒ
    for i = 1,CC.MyThingNum do
        if JY.Base["��Ʒ" .. i]==thingid then
            return true;
        end
    end
    return false;
end


function instruct_19(x,y)             --�ı�����λ��
    JY.Base["��X1"]=x;
    JY.Base["��Y1"]=y;
	JY.SubSceneX=0;
	JY.SubSceneY=0;
end


function instruct_20()                 --�ж϶����Ƿ���
    if JY.Base["����" .. CC.TeamNum ] >=0 then
        return true;
    end
    return false;
end


function instruct_21(personid)               --���
    if JY.Person[personid]==nil then
        lib.Debug("instruct_21 error: personid not exist");
        return ;
    end
    local j=0;
    for i = 1, CC.TeamNum do
        if personid==JY.Base["����" .. i] then
            j=i;
            break;
        end
    end;
    if j==0 then
       return;
    end

    for  i=j+1,CC.TeamNum do
        JY.Base["����" .. i-1]=JY.Base["����" .. i];
    end
    JY.Base["����" .. CC.TeamNum]=-1;

    if JY.Person[personid]["����"]>=0 then
        JY.Thing[JY.Person[personid]["����"]]["ʹ����"]=-1;
        JY.Person[personid]["����"]=-1
    end
    if JY.Person[personid]["����"]>=0 then
        JY.Thing[JY.Person[personid]["����"]]["ʹ����"]=-1;
        JY.Person[personid]["����"]=-1;
    end

    if JY.Person[personid]["������Ʒ"]>=0 then
        JY.Thing[JY.Person[personid]["������Ʒ"]]["ʹ����"]=-1;
        JY.Person[personid]["������Ʒ"]=-1;
    end

    JY.Person[personid]["��������"]=0;
    JY.Person[personid]["��Ʒ��������"]=0;
end


function instruct_22()            --������Ϊ0
    for i = 1, CC.TeamNum do
        if JY.Base["����" .. i] >=0 then
            JY.Person[JY.Base["����" .. i]]["����"]=0;
        end
    end
end


function instruct_23(personid,value)           --�����ö�
    JY.Person[personid]["�ö�����"]=value;
    AddPersonAttrib(personid,"�ö�����",0)
end

--��ָ��
function instruct_24()
    instruct_test("ָ��24����")
end

--�����ƶ�
--Ϊ�򻯣�ʵ�����ǳ����ƶ�(x2-x1)��(y2-y1)����y��x����ˣ�x1,y1����Ϊ0
function instruct_25(x1,y1,x2,y2)             --�����ƶ�
    local sign;
    if y1 ~= y2 then
        if y2<y1 then
            sign=-1;
        else
            sign=1;
        end
        for i=y1+sign,y2,sign do
            local t1=lib.GetTime();
            JY.SubSceneY=JY.SubSceneY+sign;
	        --JY.oldSMapX=-1;
		    --JY.oldSMapY=-1;
            DrawSMap();
            ShowScreen();
            local t2=lib.GetTime();
            if (t2-t1)<CC.SceneMoveFrame then
                lib.Delay(CC.SceneMoveFrame-(t2-t1));
            end
        end
    end

    if x1 ~= x2 then
        if x2<x1 then
            sign=-1;
        else
            sign=1;
        end
        for i=x1+sign,x2,sign do
            local t1=lib.GetTime();
            JY.SubSceneX=JY.SubSceneX+sign;
			--JY.oldSMapX=-1;
			--JY.oldSMapY=-1;

            DrawSMap();
            ShowScreen();
            local t2=lib.GetTime();
            if (t2-t1)<CC.SceneMoveFrame then
                lib.Delay(CC.SceneMoveFrame-(t2-t1));
            end
        end
    end
end


function instruct_26(sceneid,id,v1,v2,v3)           --����D*���
    if sceneid==-2 then
        sceneid=JY.SubScene;
    end

    local v=GetD(sceneid,id,2);
    SetD(sceneid,id,2,v+v1);
    v=GetD(sceneid,id,3);
    SetD(sceneid,id,3,v+v2);
    v=GetD(sceneid,id,4);
    SetD(sceneid,id,4,v+v3);
end

--��ʾ���� id=-1 ����λ�ö���
function instruct_27(id,startpic,endpic)           --��ʾ����
    local old1,old2,old3;
	if id ~=-1 then
        old1=GetD(JY.SubScene,id,5);
        old2=GetD(JY.SubScene,id,6);
        old3=GetD(JY.SubScene,id,7);
    end

    --Cls();
	--ShowScreen();
    for i =startpic,endpic,2 do
        local t1=lib.GetTime();
        if id==-1 then
            JY.MyPic=i/2;
        else
            SetD(JY.SubScene,id,5,i);
            SetD(JY.SubScene,id,6,i);
            SetD(JY.SubScene,id,7,i);
        end
        DtoSMap();
        DrawSMap();
        ShowScreen();
        local t2=lib.GetTime();
    	if t2-t1<CC.AnimationFrame then
            lib.Delay(CC.AnimationFrame-(t2-t1));
	    end
    end
	if id ~=-1 then
        SetD(JY.SubScene,id,5,old1);
        SetD(JY.SubScene,id,6,old2);
        SetD(JY.SubScene,id,7,old3);
    end
end

--�ж�Ʒ��
function instruct_28(personid,vmin,vmax)          --�ж�Ʒ��
    local v=JY.Person[personid]["Ʒ��"];
    if v >=vmin and v<=vmax then
        return true;
    else
        return false;
    end
end

--�жϹ�����
function instruct_29(personid,vmin,vmax)           --�жϹ�����
    local v=JY.Person[personid]["������"];
    if v >=vmin and v<=vmax then
        return true;
    else
        return false
    end
end

--�����߶�
--Ϊ�򻯣��߶�ʹ�����ֵ(x2-x1)(y2-y1),���x1,y1����Ϊ0������һ��ҪΪ��ǰ���ꡣ
function instruct_30(x1,y1,x2,y2)                --�����߶�
    --Cls();
    --ShowScreen();

    if x1<x2 then
        for i=x1+1,x2 do
            local t1=lib.GetTime();
            instruct_30_sub(1);
            local t2=lib.GetTime();
            if (t2-t1)<CC.PersonMoveFrame then
                lib.Delay(CC.PersonMoveFrame-(t2-t1));
            end
        end
    elseif x1>x2 then
        for i=x2+1,x1 do
            local t1=lib.GetTime();
            instruct_30_sub(2);
            local t2=lib.GetTime();
            if (t2-t1)<CC.PersonMoveFrame then
                lib.Delay(CC.PersonMoveFrame-(t2-t1));
            end
        end
    end

    if y1<y2 then
        for i=y1+1,y2 do
            local t1=lib.GetTime();
            instruct_30_sub(3);
            local t2=lib.GetTime();
            if (t2-t1)<CC.PersonMoveFrame then
                lib.Delay(CC.PersonMoveFrame-(t2-t1));
            end
        end
    elseif y1>y2 then
        for i=y2+1,y1 do
            local t1=lib.GetTime();
            instruct_30_sub(0);
            local t2=lib.GetTime();
            if (t2-t1)<CC.PersonMoveFrame then
                lib.Delay(CC.PersonMoveFrame-(t2-t1));
            end
        end
    end
end

--�����߶�sub
function instruct_30_sub(direct)            --�����߶�sub
    local x,y;
    AddMyCurrentPic();
    x=JY.Base["��X1"]+CC.DirectX[direct+1];
    y=JY.Base["��Y1"]+CC.DirectY[direct+1];
    JY.Base["�˷���"]=direct;
    JY.MyPic=GetMyPic();
    DtoSMap();

    if  SceneCanPass(x,y)==true then
        JY.Base["��X1"]=x;
        JY.Base["��Y1"]=y;
    end
    JY.Base["��X1"]=limitX(JY.Base["��X1"],1,CC.SWidth-2);
    JY.Base["��Y1"]=limitX(JY.Base["��Y1"],1,CC.SHeight-2);

    DrawSMap();
--    Cls();
    ShowScreen();
end

--�ж��Ƿ�Ǯ
function instruct_31(num)             --�ж��Ƿ�Ǯ
    local r=false;
    for i =1,CC.MyThingNum do
        if JY.Base["��Ʒ" .. i]==CC.MoneyID then
            if JY.Base["��Ʒ����" .. i]>=num then
                r=true;
            end
            break;
        end
    end
    return r;
end

--������Ʒ
--num ��Ʒ������������Ϊ������Ʒ
function instruct_32(thingid,num)           --������Ʒ
    local p=1;
    for i=1,CC.MyThingNum do
        if JY.Base["��Ʒ" .. i]==thingid then
            JY.Base["��Ʒ����" .. i]=JY.Base["��Ʒ����" .. i]+num
            p=i;
            break;
        elseif JY.Base["��Ʒ" .. i]==-1 then
            JY.Base["��Ʒ" .. i]=thingid;
            JY.Base["��Ʒ����" .. i]=num;
            p=1;
            break;
        end
    end

    if JY.Base["��Ʒ����" .. p] <=0 then
        for i=p+1,CC.MyThingNum do
            JY.Base["��Ʒ" .. i-1]=JY.Base["��Ʒ" .. i];
            JY.Base["��Ʒ����" .. i-1]=JY.Base["��Ʒ����" .. i];
        end
        JY.Base["��Ʒ" .. CC.MyThingNum]=-1;
        JY.Base["��Ʒ����" .. CC.MyThingNum]=0;
    end
end

--ѧ���书
function instruct_33(personid,wugongid,flag)           --ѧ���书
    local add=0;
    for i=1,10 do
        if JY.Person[personid]["�书" .. i]==0 then
            JY.Person[personid]["�书" .. i]=wugongid;
            JY.Person[personid]["�书�ȼ�" .. i]=0;
            add=1
            break;
        end
    end

    if add==0 then      --���书�������������һ���书
        JY.Person[personid]["�书10" ]=wugongid;
        JY.Person[personid]["�书�ȼ�10"]=0;
    end

    if flag==0 then
        DrawStrBoxWaitKey(string.format("%s ѧ���书 %s",JY.Person[personid]["����"],JY.Wugong[wugongid]["����"]),C_ORANGE,CC.DefaultFont);
    end
end

--��������
function instruct_34(id,value)              --��������
    local add,str=AddPersonAttrib(id,"����",value);
    DrawStrBoxWaitKey(JY.Person[id]["����"] .. str,C_ORANGE,CC.DefaultFont);
end

--�����书
function instruct_35(personid,id,wugongid,wugonglevel)         --�����书
    if id>=0 then
        JY.Person[personid]["�书" .. id+1]=wugongid;
        JY.Person[personid]["�书�ȼ�" .. id+1]=wugonglevel;
    else
        local flag=0;
        for i =1,10 do
            if JY.Person[personid]["�书" .. i]==0 then
                flag=1;
                JY.Person[personid]["�书" .. i]=wugongid;
                JY.Person[personid]["�书�ȼ�" .. i]=wugonglevel;
                return;
            end
        end
        if flag==0 then
            JY.Person[personid]["�书" .. 1]=wugongid;
            JY.Person[personid]["�书�ȼ�" .. 1]=wugonglevel;
        end
    end
end

--�ж������Ա�
function instruct_36(sex)               --�ж������Ա�
    if JY.Person[0]["�Ա�"]==sex then
        return true;
    else
        return false;
    end
end


function instruct_37(v)              --����Ʒ��
    AddPersonAttrib(0,"Ʒ��",v);
end

--�޸ĳ���ĳ����ͼ
function instruct_38(sceneid,level,oldpic,newpic)         --�޸ĳ���ĳ����ͼ
    if sceneid==-2 then
        sceneid=JY.SubScene;
    end

    for i=0,CC.SWidth-1 do
        for j=1, CC.SHeight-1 do
            if GetS(sceneid,i,j,level)==oldpic then
                SetS(sceneid,i,j,level,newpic)
            end
        end
    end
end


function instruct_39(sceneid)             --�򿪳���
    JY.Scene[sceneid]["��������"]=0;
end


function instruct_40(v)                --�ı����Ƿ���
    JY.Base["�˷���"]=v;
    JY.MyPic=GetMyPic();
end


function instruct_41(personid,thingid,num)        --������Ա������Ʒ
    local k=0;
    for i =1, 4 do        --������Ʒ
        if JY.Person[personid]["Я����Ʒ" .. i]==thingid then
            JY.Person[personid]["Я����Ʒ����" .. i]=JY.Person[personid]["Я����Ʒ����" .. i]+num;
            k=i;
            break
        end
    end

    --��Ʒ���ٵ�0���������Ʒ��ǰ�ƶ�
    if k>0 and JY.Person[personid]["Я����Ʒ����" .. k] <=0 then
        for i=k+1,4 do
            JY.Person[personid]["Я����Ʒ" .. i-1]=JY.Person[personid]["Я����Ʒ" .. i];
            JY.Person[personid]["Я����Ʒ����" .. i-1]=JY.Person[personid]["Я����Ʒ����" .. i];
        end
        JY.Person[personid]["Я����Ʒ" .. 4]=-1;
        JY.Person[personid]["Я����Ʒ����" .. 4]=0;
    end


    if k==0 then    --û����Ʒ��ע��˴������ǳ���4����Ʒ�������������������޷����롣
        for i =1, 4 do        --������Ʒ
            if JY.Person[personid]["Я����Ʒ" .. i]==-1 then
                JY.Person[personid]["Я����Ʒ" .. i]=thingid;
                JY.Person[personid]["Я����Ʒ����" .. i]=num;
                break
            end
        end
    end
end


function instruct_42()          --�������Ƿ���Ů��
    local r=false;
    for i =1,CC.TeamNum do
        if JY.Base["����" .. i] >=0 then
            if JY.Person[JY.Base["����" .. i]]["�Ա�"]==1 then
                r=true;
            end
        end
    end
    return r;
end


function instruct_43(thingid)        --�Ƿ���ĳ����Ʒ
    return instruct_18(thingid);
end


function instruct_44(id1,startpic1,endpic1,id2,startpic2,endpic2)     --ͬʱ��ʾ��������
    local old1=GetD(JY.SubScene,id1,5);
    local old2=GetD(JY.SubScene,id1,6);
    local old3=GetD(JY.SubScene,id1,7);
    local old4=GetD(JY.SubScene,id2,5);
    local old5=GetD(JY.SubScene,id2,6);
    local old6=GetD(JY.SubScene,id2,7);

    --Cls();
    --ShowScreen();
    for i =startpic1,endpic1,2 do
        local t1=lib.GetTime();
        if id1==-1 then
            JY.MyPic=i/2;
        else
            SetD(JY.SubScene,id1,5,i);
            SetD(JY.SubScene,id1,6,i);
            SetD(JY.SubScene,id1,7,i);
        end
        if id2==-1 then
            JY.MyPic=i/2;
        else
            SetD(JY.SubScene,id2,5,i-startpic1+startpic2);
            SetD(JY.SubScene,id2,6,i-startpic1+startpic2);
            SetD(JY.SubScene,id2,7,i-startpic1+startpic2);
        end
        DtoSMap();
        DrawSMap();
        ShowScreen();
        local t2=lib.GetTime();
    	if t2-t1<CC.AnimationFrame then
            lib.Delay(CC.AnimationFrame-(t2-t1));
	    end
    end
    SetD(JY.SubScene,id1,5,old1);
    SetD(JY.SubScene,id1,6,old2);
    SetD(JY.SubScene,id1,7,old3);
    SetD(JY.SubScene,id2,5,old4);
    SetD(JY.SubScene,id2,6,old5);
    SetD(JY.SubScene,id2,7,old6);

end


function instruct_45(id,value)        --�����Ṧ
    local add,str=AddPersonAttrib(id,"�Ṧ",value);
    DrawStrBoxWaitKey(JY.Person[id]["����"] .. str,C_ORANGE,CC.DefaultFont);
end


function instruct_46(id,value)            --��������
    local add,str=AddPersonAttrib(id,"�������ֵ",value);
    AddPersonAttrib(id,"����",0);
    DrawStrBoxWaitKey(JY.Person[id]["����"] .. str,C_ORANGE,CC.DefaultFont);
end


function instruct_47(id,value)
    local add,str=AddPersonAttrib(id,"������",value);           --���ӹ�����
    DrawStrBoxWaitKey(JY.Person[id]["����"] .. str,C_ORANGE,CC.DefaultFont);
end


function instruct_48(id,value)         --��������
    local add,str=AddPersonAttrib(id,"�������ֵ",value);
    AddPersonAttrib(id,"����",0);
    if instruct_16(id)==true then             --�ҷ���Ա����ʾ����
        DrawStrBoxWaitKey(JY.Person[id]["����"] .. str,C_ORANGE,CC.DefaultFont);
    end
end


function instruct_49(personid,value)       --������������
    JY.Person[personid]["��������"]=value;
end

--�ж��Ƿ���5����Ʒ
function instruct_50(id1,id2,id3,id4,id5)       --�ж��Ƿ���5����Ʒ
    local num=0;
    if instruct_18(id1)==true then
        num=num+1;
    end
    if instruct_18(id2)==true then
        num=num+1;
    end
    if instruct_18(id3)==true then
        num=num+1;
    end
    if instruct_18(id4)==true then
        num=num+1;
    end
    if instruct_18(id5)==true then
        num=num+1;
    end
    if num==5 then
        return true;
    else
        return false;
    end
end


function instruct_51()     --����������
    instruct_1(2547+Rnd(18),114,0);
end


function instruct_52()       --��Ʒ��
    DrawStrBoxWaitKey(string.format("�����ڵ�Ʒ��ָ��Ϊ: %d",JY.Person[0]["Ʒ��"]),C_ORANGE,CC.DefaultFont);
end


function instruct_53()        --������
    DrawStrBoxWaitKey(string.format("�����ڵ�����ָ��Ϊ: %d",JY.Person[0]["����"]),C_ORANGE,CC.DefaultFont);
end


function instruct_54()        --������������
    for i = 0, JY.SceneNum-1 do
        JY.Scene[i]["��������"]=0;
    end
    JY.Scene[2]["��������"]=2;    --�ƺ���
    JY.Scene[38]["��������"]=2;   --Ħ����
    JY.Scene[75]["��������"]=1;   --�һ���
    JY.Scene[80]["��������"]=1;   --����ȵ�
end


function instruct_55(id,num)      --�ж�D*��ŵĴ����¼�
    if GetD(JY.SubScene,id,2)==num then
        return true;
    else
        return false;
    end
end


function instruct_56(v)             --��������
    JY.Person[0]["����"]=JY.Person[0]["����"]+v;
    instruct_2_sub();     --�Ƿ��������������
end

--�߲��Թ�����
function instruct_57()       --�߲��Թ�����
    instruct_27(-1,7664,7674);
    --Cls();
	--ShowScreen();
    for i=0,56,2 do
	    local t1=lib.GetTime();
        if JY.MyPic< 7688/2 then
            JY.MyPic=(7676+i)/2;
        end
        SetD(JY.SubScene,2,5,i+7690);
        SetD(JY.SubScene,2,6,i+7690);
        SetD(JY.SubScene,2,7,i+7690);
        SetD(JY.SubScene,3,5,i+7748);
        SetD(JY.SubScene,3,6,i+7748);
        SetD(JY.SubScene,3,7,i+7748);
        SetD(JY.SubScene,4,5,i+7806);
        SetD(JY.SubScene,4,6,i+7806);
        SetD(JY.SubScene,4,7,i+7806);

        DtoSMap();
        DrawSMap();
        ShowScreen();
        local t2=lib.GetTime();
    	if t2-t1<CC.AnimationFrame then
            lib.Delay(CC.AnimationFrame-(t2-t1));
	    end
    end
end

--���������
function instruct_58()           --���������
    local group=5           --���������
    local num1 = 6          --ÿ���м���ս��
    local num2 = 3          --ѡ���ս����
    local startwar=102      --��ʼս�����
    local flag={};

    for i = 0,group-1 do
        for j=0,num1-1 do
            flag[j]=0;
        end

        for j = 1,num2 do
            local r;
            while true do          --ѡ��һ��ս��
                r=Rnd(num1);
                if flag[r]==0 then
                    flag[r]=1;
                    break;
                end
            end
            local warnum =r+i*num1;      --������ս�����
            WarLoad(warnum + startwar);
            instruct_1(2854+warnum, JY.Person[WAR.Data["����1"]]["ͷ�����"], 0);
            instruct_0();
            if WarMain(warnum + startwar, 0) ==true  then     --Ӯ
                instruct_0();
                instruct_13();
                TalkEx("������λǰ���ϴͽ̣�", 0, 1)
                instruct_0();
            else
                instruct_15();
                return;
            end
        end

        if i < group - 1 then
            TalkEx("��������ս������*������Ϣ��ս��", 70, 0);
            instruct_0();
            instruct_14();
            lib.Delay(300);
            if JY.Person[0]["���˳̶�"] < 50 and JY.Person[0]["�ж��̶�"] <= 0 then
               JY.Person[0]["���˳̶�"] = 0
               AddPersonAttrib(0,"����",math.huge);
               AddPersonAttrib(0,"����",math.huge);
               AddPersonAttrib(0,"����",math.huge);
            end
            instruct_13();
            TalkEx("���Ѿ���Ϣ���ˣ�*��˭Ҫ���ϣ�",0,1);
            instruct_0();
        end
    end

    TalkEx("��������˭��**��������*��������***û��������",0,1);
    instruct_0();
    TalkEx("�����û����Ҫ��������λ*������ս���������书����*��һ֮������������֮λ��*������λ������ã�***������������*������������*������������*�ã���ϲ����������������*֮λ����������ã������*���������ȡ�Ҳ���㱣�ܣ�",70,0);
    instruct_0();
    TalkEx("��ϲ������",12,0);
    instruct_0();
    TalkEx("С�ֵܣ���ϲ�㣡",64,4);
    instruct_0();
    TalkEx("�ã���������ִ�ᵽ����*Բ��������ϣ�������λ��*��ͬ�����ٵ��һ�ɽһ�Σ�",19,0);
    instruct_0();
    instruct_14();
    for i = 24,72 do
        instruct_3(-2, i, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2)
    end
    instruct_0();
    instruct_13();
    TalkEx("����ǧ����࣬����춴��*Ⱥ�ۣ��õ�����������֮λ*�����ȣ�*���ǡ�ʥ�á������أ�*Ϊʲ��û�˸����ң��ѵ���*�Ҷ���֪����*�������е����ˣ�", 0, 1)
    instruct_0();
    instruct_2(143, 1)           --�õ�����

end

--ȫ���Ա���
function instruct_59()           --ȫ���Ա���
    for i=CC.TeamNum,2,-1 do
	    if JY.Base["����" .. i]>=0 then
            instruct_21(JY.Base["����" .. i]);
	    end
    end

    for i,v in ipairs(CC.AllPersonExit) do
        instruct_3(v[1],v[2],0,0,-1,-1,-1,-1,-1,-1,0,-2,-2);
    end
end

--�ж�D*ͼƬ
function instruct_60(sceneid,id,num)          --�ж�D*ͼƬ
    if sceneid==-2 then
         sceneid=JY.SubScene;
    end

    if id==-2 then
         id=JY.CurrentD;
    end

    if GetD(sceneid,id,5)==num then
        return true;
    else
        return false;
    end
end

--�ж��Ƿ����14����
function instruct_61()               --�ж��Ƿ����14����
    for i=11,24 do
        if GetD(JY.SubScene,i,5) ~= 4664 then
            return false;
        end
    end
    return true;
end

--����ʱ�ջ�����������
function instruct_62(id1,startnum1,endnum1,id2,startnum2,endnum2)      --����ʱ�ջ�����������
      JY.MyPic=-1;
      instruct_44(id1,startnum1,endnum1,id2,startnum2,endnum2);

      --�˴�Ӧ�ò��������Ƭβ������������ʱ��ͼƬ����

	  lib.LoadPicture(CONFIG.PicturePath .."end.png",-1,-1);
	  ShowScreen();
	  PlayMIDI(24);
	  lib.Delay(5000);
	  lib.GetKey();
	  WaitKey();
	  JY.Status=GAME_END;
end

--�����Ա�
function instruct_63(personid,sex)          --�����Ա�
    JY.Person[personid]["�Ա�"]=sex
end

--С��������
function instruct_64()                 --С��������
    local headid=111;           --С��ͷ��


    local id=-1;
    for i=0,JY.ShopNum-1 do                --�ҵ���ǰ�̵�id
        if CC.ShopScene[i].sceneid==JY.SubScene then
            id=i;
            break;
        end
    end
    if id<0 then
        return ;
    end

    TalkEx("��λС�磬������ʲ����Ҫ*�ģ�С�������Ķ�����Ǯ��*�Թ�����",headid,0);

    local menu={};
    for i=1,5 do
        menu[i]={};
        local thingid=JY.Shop[id]["��Ʒ" ..i];
        menu[i][1]=string.format("%-12s %5d",JY.Thing[thingid]["����"],JY.Shop[id]["��Ʒ�۸�" ..i]);
        menu[i][2]=nil;
        if JY.Shop[id]["��Ʒ����" ..i] >0 then
            menu[i][3]=1;
        else
            menu[i][3]=0;
        end
    end

    local x1=(CC.ScreenW-9*CC.DefaultFont-2*CC.MenuBorderPixel)/2;
    local y1=(CC.ScreenH-5*CC.DefaultFont-4*CC.RowPixel-2*CC.MenuBorderPixel)/2;



    local r=ShowMenu(menu,5,0,x1,y1,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r>0 then
        if instruct_31(JY.Shop[id]["��Ʒ�۸�" ..r])==false then
            TalkEx("�ǳ���Ǹ��*�����ϵ�Ǯ�ƺ�������",headid,0);
        else
            JY.Shop[id]["��Ʒ����" ..r]=JY.Shop[id]["��Ʒ����" ..r]-1;
            instruct_32(CC.MoneyID,-JY.Shop[id]["��Ʒ�۸�" ..r]);
            instruct_32(JY.Shop[id]["��Ʒ" ..r],1);
            TalkEx("��ү������С���Ķ�����*��֤������ڣ�",headid,0);
        end
    end

    for i,v in ipairs(CC.ShopScene[id].d_leave) do
        instruct_3(-2,v,0,-2,-1,-1,939,-1,-1,-1,-2,-2,-2);      --�����뿪����ʱ����С���뿪�¼���
    end
end

--С��ȥ������ջ
function instruct_65()           --С��ȥ������ջ
    local id=-1;
    for i=0,JY.ShopNum-1 do                --�ҵ���ǰ�̵�id
        if CC.ShopScene[i].sceneid==JY.SubScene then
            id=i;
            break;
        end
    end
    if id<0 then
        return ;
    end

    ---�����ǰ�̵�����С��D��
    instruct_3(-2,CC.ShopScene[id].d_shop,0,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
    for i,v in ipairs(CC.ShopScene[id].d_leave) do
        instruct_3(-2,v,0,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
    end

    local newid=id+1;              --��ʱ��˳��ȡ�������
    if newid>=5 then
        newid=0;
    end

    --�����µ�С���̵�λ��
    instruct_3(CC.ShopScene[newid].sceneid,CC.ShopScene[newid].d_shop,1,-2,938,-1,-1,8256,8256,8256,-2,-2,-2);
end

--��������
function instruct_66(id)       --��������
    PlayMIDI(id);
end

--������Ч
function instruct_67(id)      --������Ч
     PlayWavAtk(id);
end





---------------------------------------------------------------------------
---------------------------------ս��-----------------------------------
--��ں���ΪWarMain����ս��ָ�����

--����ս��ȫ�̱���
function WarSetGlobal()            --����ս��ȫ�̱���
    WAR={};

    WAR.Data={};              --ս����Ϣ��war.sta�ļ�

    WAR.SelectPerson={}            --����ѡ���ս��  0 δѡ��1 ѡ������ȡ����2 ѡ����ȡ����ѡ���չ�˲˵�����ʹ��

    WAR.Person={};                 --ս��������Ϣ
    for i=0,26-1 do
        WAR.Person[i]={};
        WAR.Person[i]["������"]=-1;
        WAR.Person[i]["�ҷ�"]=true;            --true �ҷ���false����
        WAR.Person[i]["����X"]=-1;
        WAR.Person[i]["����Y"]=-1;
        WAR.Person[i]["����"]=true;
        WAR.Person[i]["�˷���"]=-1;
        WAR.Person[i]["��ͼ"]=-1;
        WAR.Person[i]["��ͼ����"]=0;        --0 wmap����ͼ��1 fight***����ͼ
        WAR.Person[i]["�Ṧ"]=0;
        WAR.Person[i]["�ƶ�����"]=0;
        WAR.Person[i]["����"]=0;
        WAR.Person[i]["����"]=0;
        WAR.Person[i]["�Զ�ѡ�����"]=-1;     --�Զ�ս����ÿ����ѡ���ս������
   end

    WAR.PersonNum=0;               --ս���������

    WAR.AutoFight=0;               --�ҷ��Զ�ս������ 0 �ֶ���1 �Զ���

    WAR.CurID=-1;                  --��ǰ����ս����id

	WAR.ShowHead=0;                --�Ƿ���ʾͷ��

    WAR.Effect=0;              --Ч��������ȷ������ͷ�����ֵ���ɫ
	                           --2 ɱ���� , 3 ɱ����, 4 ҽ�� �� 5 �ö� �� 6 �ⶾ

    WAR.EffectColor={};      ---��������ͷ�����ֵ���ɫ
    WAR.EffectColor[2]=RGB(236, 200, 40);
    WAR.EffectColor[3]=RGB(112, 12, 112);
    WAR.EffectColor[4]=RGB(236, 200, 40);
    WAR.EffectColor[5]=RGB(96, 176, 64)
    WAR.EffectColor[6]=RGB(104, 192, 232);

	WAR.EffectXY=nil            --�����书Ч������������
	WAR.EffectXYNum=0;          --�������

end

--����ս������
function WarLoad(warid)              --����ս������
    WarSetGlobal();         --��ʼ��ս������
    local data=Byte.create(CC.WarDataSize);      --��ȡս������
    Byte.loadfile(data,CC.WarFile,warid*CC.WarDataSize,CC.WarDataSize);
    LoadData(WAR.Data,CC.WarData_S,data);
end

--ս��������
--warid  ս�����
--isexp  ����Ƿ��о��� 0 û���飬1 �о���
--����  true ս��ʤ����false ʧ��
function WarMain(warid,isexp)           --ս��������
    lib.Debug(string.format("war start. warid=%d",warid));
    WarLoad(warid);
    WarSelectTeam();          --ѡ���ҷ�
    WarSelectEnemy();         --ѡ�����

    CleanMemory()
    lib.PicInit();
 	lib.ShowSlow(50,1) ;      --�����䰵

    WarLoadMap(WAR.Data["��ͼ"]);       --����ս����ͼ

    JY.Status=GAME_WMAP;

	--������ͼ�ļ�
    lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],0);
    lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],1);
	if CC.LoadThingPic==1 then
        lib.PicLoadFile(CC.ThingPicFile[1],CC.ThingPicFile[2],2);
	end
    lib.PicLoadFile(CC.EffectFile[1],CC.EffectFile[2],3);

    PlayMIDI(WAR.Data["����"]);

    local first=0;            --��һ����ʾս�����
    local warStatus;          --ս��״̬

	WarPersonSort();    --ս���˰��Ṧ����

	for i=0,WAR.PersonNum-1 do
        local pid=WAR.Person[i]["������"];
		lib.PicLoadFile(string.format(CC.FightPicFile[1],JY.Person[pid]["ͷ�����"]),
		                string.format(CC.FightPicFile[2],JY.Person[pid]["ͷ�����"]),
						4+i);
	end

    while true do             --ս����ѭ��

        for i=0,WAR.PersonNum-1 do
            WAR.Person[i]["��ͼ"]=WarCalPersonPic(i);
        end
		for i=0,WAR.PersonNum-1 do                ---������˵��Ṧ������װ���ӳ�
			local id=WAR.Person[i]["������"];
			local move=math.modf(WAR.Person[i]["�Ṧ"]/15)-math.modf(JY.Person[id]["���˳̶�"]/40);
			if move<0 then
				move=0;
			end
			WAR.Person[i]["�ƶ�����"]=move;
		end

		WarSetPerson();     --����ս������λ��

        local p=0;
        while p<WAR.PersonNum do       --ÿ�غ�ս��ѭ����ÿ��������ս��
            collectgarbage("step",0);
		    WAR.Effect=0;
            if WAR.AutoFight==1 then                 --�ҷ��Զ�ս��ʱ��ȡ���̣����Ƿ�ȡ��
                local keypress=lib.GetKey();
                if keypress==VK_SPACE or keypress==VK_RETURN then
                    WAR.AutoFight=0;
                end
            end


            if WAR.Person[p]["����"]==false then

                WAR.CurID=p;

                if first==0 then              --��һ�ν�����ʾ
                    WarDrawMap(0);
	                lib.ShowSlow(50,0)
                    first=1;
                else
--                    WarDrawMap(0);
                    --WarShowHead();
--                    ShowScreen();
                end

                local r;
                if WAR.Person[p]["�ҷ�"]==true then
                    if WAR.AutoFight==0 then
                        r=War_Manual();                  --�ֶ�ս��
                    else
                        r=War_Auto();                  --�Զ�ս��
                    end
                else
                    r=War_Auto();                  --�Զ�ս��
                end

                warStatus=War_isEnd();        --ս���Ƿ������   0������1Ӯ��2��

                if math.abs(r)==7 then         --�ȴ�
                    p=p-1;
                end

                if warStatus>0 then
                    break;
                end

            end
            p=p+1;
        end

        if warStatus>0 then
            break;
        end

        War_PersonLostLife();

    end

    local r;

	WAR.ShowHead=0;

	if warStatus==1 then
        DrawStrBoxWaitKey("ս��ʤ��",C_WHITE,CC.DefaultFont);
        r=true;
    elseif warStatus==2 then
        DrawStrBoxWaitKey("ս��ʧ��",C_WHITE,CC.DefaultFont);
        r=false;
    end

    War_EndPersonData(isexp,warStatus);    --ս���������������

    lib.ShowSlow(50,1);

    if JY.Scene[JY.SubScene]["��������"]>=0 then
        PlayMIDI(JY.Scene[JY.SubScene]["��������"]);
    else
        PlayMIDI(0);
    end

    CleanMemory();
    lib.PicInit();
    lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],0);
    lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],1);
	if CC.LoadThingPic==1 then
        lib.PicLoadFile(CC.ThingPicFile[1],CC.ThingPicFile[2],2);
	end

    JY.Status=GAME_SMAP;

    return r;
end


function War_PersonLostLife()             --����ս����ÿ�غ������ж������˶���Ѫ
    for i=0,WAR.PersonNum-1 do
        local pid=WAR.Person[i]["������"]
        if WAR.Person[i]["����"]==false then
            if JY.Person[pid]["���˳̶�"]>0 then
                local dec=math.modf(JY.Person[pid]["���˳̶�"]/20);
                AddPersonAttrib(pid,"����",-dec);
            end
            if JY.Person[pid]["�ж��̶�"]>0 then
                local dec=math.modf(JY.Person[pid]["�ж��̶�"]/10);
                AddPersonAttrib(pid,"����",-dec);
            end
            if JY.Person[pid]["����"]<=0 then
                JY.Person[pid]["����"]=1;
            end
        end
    end
end


function War_EndPersonData(isexp,warStatus)            --ս���Ժ������������
--�з���Ա�����ָ�
    for i=0,WAR.PersonNum-1 do
        local pid=WAR.Person[i]["������"]
        if WAR.Person[i]["�ҷ�"]==false then
            JY.Person[pid]["����"]=JY.Person[pid]["�������ֵ"];
            JY.Person[pid]["����"]=JY.Person[pid]["�������ֵ"];
            JY.Person[pid]["����"]=CC.PersonAttribMax["����"];
            JY.Person[pid]["���˳̶�"]=0;
            JY.Person[pid]["�ж��̶�"]=0;
        end
    end

    --�ҷ���Ա�����ָ�����Ӯ����
    for i=0,WAR.PersonNum-1 do
        local pid=WAR.Person[i]["������"]
        if WAR.Person[i]["�ҷ�"]==true then
            if JY.Person[pid]["����"]<JY.Person[pid]["�������ֵ"]/5 then
                JY.Person[pid]["����"]=math.modf(JY.Person[pid]["�������ֵ"]/5);
            end
            if JY.Person[pid]["����"]<10 then
                JY.Person[pid]["����"]=10 ;
            end
        end
    end

    if warStatus==2 and isexp==0 then  --�䣬û�о��飬�˳�
        return ;
    end

    local liveNum=0;          --�����ҷ����ŵ�����
    for i=0,WAR.PersonNum-1 do
        if WAR.Person[i]["�ҷ�"]==true and JY.Person[WAR.Person[i]["������"]]["����"]>0  then
            liveNum=liveNum+1;
        end
    end

    --����ս������---�������飬ս�������е�
    if warStatus==1 then     --Ӯ�˲���
        for i=0,WAR.PersonNum-1 do
            local pid=WAR.Person[i]["������"]
            if WAR.Person[i]["�ҷ�"]==true then
                if JY.Person[pid]["����"]>0 then
                    WAR.Person[i]["����"]=WAR.Person[i]["����"] + math.modf(WAR.Data["����"]/liveNum);
                end
            end
        end
    end


    --ÿ���˾������ӣ��Լ�����
    for i=0,WAR.PersonNum-1 do
        local pid=WAR.Person[i]["������"];
        AddPersonAttrib(pid,"��Ʒ��������",math.modf(WAR.Person[i]["����"]*8/10));
        AddPersonAttrib(pid,"��������",math.modf(WAR.Person[i]["����"]*8/10));
        AddPersonAttrib(pid,"����",WAR.Person[i]["����"]);

        if WAR.Person[i]["�ҷ�"]==true then

            DrawStrBoxWaitKey( string.format("%s ��þ������ %d",JY.Person[pid]["����"],WAR.Person[i]["����"]),C_WHITE,CC.DefaultFont);

			local r=War_AddPersonLevel(pid);     --��������

			if r==true then
				DrawStrBoxWaitKey( string.format("%s ������",JY.Person[pid]["����"]),C_WHITE,CC.DefaultFont);
			end
        end

        War_PersonTrainBook(pid);            --�����ؼ�
        War_PersonTrainDrug(pid);            --����ҩƷ
    end
end

--�����Ƿ�����
--pid ��id
--���� true ������false������
function War_AddPersonLevel(pid)      --�����Ƿ�����

    local tmplevel=JY.Person[pid]["�ȼ�"];
    if tmplevel>=CC.Level then     --���𵽶�
        return false;
    end

    if JY.Person[pid]["����"]<CC.Exp[tmplevel] then     --���鲻������
        return false
    end

    while true do          --�жϿ���������
        if tmplevel >= CC.Level then
            break;
        end
        if JY.Person[pid]["����"]>=CC.Exp[tmplevel] then
            tmplevel=tmplevel+1;
        else
            break;
        end
    end
    local leveladd=tmplevel-JY.Person[pid]["�ȼ�"];   --��������
    JY.Person[pid]["�ȼ�"]=JY.Person[pid]["�ȼ�"]+leveladd;
    AddPersonAttrib(pid,"�������ֵ", (JY.Person[pid]["��������"]+Rnd(3))*leveladd*3);
    JY.Person[pid]["����"]=JY.Person[pid]["�������ֵ"];
    JY.Person[pid]["����"]=CC.PersonAttribMax["����"];
    JY.Person[pid]["���˳̶�"]=0;
    JY.Person[pid]["�ж��̶�"]=0;

    local cleveradd;
    if JY.Person[pid]["����"]<30 then
        cleveradd=2;
    elseif JY.Person[pid]["����"]<50 then
        cleveradd=3;
    elseif JY.Person[pid]["����"]<70 then
        cleveradd=4;
    elseif JY.Person[pid]["����"]<90 then
        cleveradd=5;
    else
        cleveradd=6;
    end
    cleveradd=Rnd(cleveradd)+1;        --�������ʼ���������㣬Խ����������Խ�࣬����������Խ�١�
    AddPersonAttrib(pid,"�������ֵ",  (9-cleveradd)*leveladd*4);   --�����˲�������
    JY.Person[pid]["����"]=JY.Person[pid]["�������ֵ"];

    AddPersonAttrib(pid,"������",  cleveradd*leveladd);
    AddPersonAttrib(pid,"������",  cleveradd*leveladd);
    AddPersonAttrib(pid,"�Ṧ",  cleveradd*leveladd);

    if JY.Person[pid]["ҽ������"]>=20 then
        AddPersonAttrib(pid,"ҽ������",  Rnd(3));
    end
    if JY.Person[pid]["�ö�����"]>=20 then
        AddPersonAttrib(pid,"�ö�����",  Rnd(3));
    end
    if JY.Person[pid]["�ⶾ����"]>=20 then
        AddPersonAttrib(pid,"�ⶾ����",  Rnd(3));
    end
    if JY.Person[pid]["ȭ�ƹ���"]>=20 then
        AddPersonAttrib(pid,"ȭ�ƹ���",  Rnd(3));
    end
    if JY.Person[pid]["��������"]>=20 then
        AddPersonAttrib(pid,"��������",  Rnd(3));
    end
    if JY.Person[pid]["ˣ������"]>=20 then
        AddPersonAttrib(pid,"ˣ������",  Rnd(3));
    end
    if JY.Person[pid]["��������"]>=20 then
        AddPersonAttrib(pid,"��������",  Rnd(3));
    end

    return true;

end

--�����ؼ�
function War_PersonTrainBook(pid)           --ս���������ؼ��Ƿ�ɹ�
    local p=JY.Person[pid];

    local thingid=p["������Ʒ"];
    if thingid<0 then
        return ;
    end

    local wugongid=JY.Thing[thingid]["�����书"];

    local needpoint=TrainNeedExp(pid);      --���������ɹ���Ҫ����

    if p["��������"]>=needpoint then   --�����ɹ�

        DrawStrBoxWaitKey( string.format("%s ���� %s �ɹ�",p["����"],JY.Thing[thingid]["����"]),C_WHITE,CC.DefaultFont);

        AddPersonAttrib(pid,"�������ֵ",JY.Thing[thingid]["���������ֵ"]);
        if JY.Thing[thingid]["�ı���������"]==2 then
            p["��������"]=2;
        end
        AddPersonAttrib(pid,"�������ֵ",JY.Thing[thingid]["���������ֵ"]);
        AddPersonAttrib(pid,"������",JY.Thing[thingid]["�ӹ�����"]);
        AddPersonAttrib(pid,"�Ṧ",JY.Thing[thingid]["���Ṧ"]);
        AddPersonAttrib(pid,"������",JY.Thing[thingid]["�ӷ�����"]);
        AddPersonAttrib(pid,"ҽ������",JY.Thing[thingid]["��ҽ������"]);
        AddPersonAttrib(pid,"�ö�����",JY.Thing[thingid]["���ö�����"]);
        AddPersonAttrib(pid,"�ⶾ����",JY.Thing[thingid]["�ӽⶾ����"]);
        AddPersonAttrib(pid,"��������",JY.Thing[thingid]["�ӿ�������"]);
        AddPersonAttrib(pid,"ȭ�ƹ���",JY.Thing[thingid]["��ȭ�ƹ���"]);
        AddPersonAttrib(pid,"��������",JY.Thing[thingid]["����������"]);
        AddPersonAttrib(pid,"ˣ������",JY.Thing[thingid]["��ˣ������"]);
        AddPersonAttrib(pid,"�������",JY.Thing[thingid]["���������"]);
        AddPersonAttrib(pid,"��������",JY.Thing[thingid]["�Ӱ�������"]);
        AddPersonAttrib(pid,"��ѧ��ʶ",JY.Thing[thingid]["����ѧ��ʶ"]);
        AddPersonAttrib(pid,"Ʒ��",JY.Thing[thingid]["��Ʒ��"]);
        AddPersonAttrib(pid,"��������",JY.Thing[thingid]["�ӹ�������"]);
        if JY.Thing[thingid]["�ӹ�������"]==1 then
            p["���һ���"]=1;
        end

        p["��������"]=0;

        if wugongid>=0 then
            local oldwugong=0;
            for i =1,10 do
                if p["�书" .. i]==wugongid then
                    oldwugong=1;
                    p["�书�ȼ�" .. i]=p["�书�ȼ�" .. i]+100;

                    DrawStrBoxWaitKey(string.format("%s ��Ϊ��%s��",JY.Wugong[wugongid]["����"],math.modf(p["�书�ȼ�" ..i]/100)+1),C_WHITE,CC.DefaultFont);

                    break;
                end
            end
            if oldwugong==0 then  --�µ��书
                for i=1,10 do
                    if p["�书" .. i]==0 then
                        p["�书" .. i]=wugongid;
                        break;
                    end
                end
                ---���ﲻ����10���书������ʱ����������µ��书
            end
        end
    end
end

--����ҩƷ
function War_PersonTrainDrug(pid)         --ս�����Ƿ���������Ʒ
    local p=JY.Person[pid];

    local thingid=p["������Ʒ"];
    if thingid<0 then
        return ;
    end

    if JY.Thing[thingid]["������Ʒ�辭��"] <=0 then          --��������������Ʒ
        return ;
    end

    local needpoint=(7-math.modf(p["����"]/15))*JY.Thing[thingid]["������Ʒ�辭��"];
    if p["��Ʒ��������"]< needpoint then
        return ;
    end

    local haveMaterial=0;       --�Ƿ�����Ҫ�Ĳ���
    local MaterialNum=-1;
    for i=1,CC.MyThingNum do
        if JY.Base["��Ʒ" .. i]==JY.Thing[thingid]["�����"] then
            haveMaterial=1;
            MaterialNum=JY.Base["��Ʒ����" .. i]
            break;
        end
    end

    if haveMaterial==1 then   --�в���
        local enough={};
        local canMake=0;
        for i=1,5 do       --������Ҫ���ϵ���������ǿ���������Щ��Ʒ
            if JY.Thing[thingid]["������Ʒ" .. i] >=0 and MaterialNum >= JY.Thing[thingid]["��Ҫ��Ʒ����" .. i] then
                canMake=1;
                enough[i]=1;
            else
                enough[i]=0;
            end
        end

        if canMake ==1 then    --��������Ʒ
            local makeID;
            while true do      --���ѡ����������Ʒ��������ǰ��enough�����б�ǿ���������
                makeID=Rnd(5)+1;
                if enough[makeID]==1 then
                    break;
                end
            end
            local newThingID=JY.Thing[thingid]["������Ʒ" .. makeID];

            DrawStrBoxWaitKey(string.format("%s ����� %s",p["����"],JY.Thing[newThingID]["����"]),C_WHITE,CC.DefaultFont);

            if instruct_18(newThingID)==true then       --�Ѿ�����Ʒ
                instruct_32(newThingID,1);
            else
                instruct_32(newThingID,1+Rnd(3));
            end

            instruct_32(JY.Thing[thingid]["�����"],-JY.Thing[thingid]["��Ҫ��Ʒ����" .. makeID]);
            p["��Ʒ��������"]=0;
        end
    end
end

--ս���Ƿ����
--���أ�0 ����   1 Ӯ    2 ��
function War_isEnd()           --ս���Ƿ����

    for i=0,WAR.PersonNum-1 do
        if JY.Person[WAR.Person[i]["������"]]["����"]<=0 then
            WAR.Person[i]["����"]=true;
        end
    end
    WarSetPerson();     --����ս������λ��

    Cls();
    ShowScreen();

    local myNum=0;
    local EmenyNum=0;
    for i=0,WAR.PersonNum-1 do
        if WAR.Person[i]["����"]==false then
            if WAR.Person[i]["�ҷ�"]==true then
                myNum=1;
            else
                EmenyNum=1;
            end
        end
    end

    if EmenyNum==0 then
        return 1;
    end
    if myNum==0 then
        return 2;
    end
    return 0;
end

--ѡ���ҷ���ս��
function WarSelectTeam()            --ѡ���ҷ���ս��
    WAR.PersonNum=0;

    for i=1,6 do
	    local id=WAR.Data["�Զ�ѡ���ս��" .. i];
		if id>=0 then
            WAR.Person[WAR.PersonNum]["������"]=id;
            WAR.Person[WAR.PersonNum]["�ҷ�"]=true;
            WAR.Person[WAR.PersonNum]["����X"]=WAR.Data["�ҷ�X"  .. i];
            WAR.Person[WAR.PersonNum]["����Y"]=WAR.Data["�ҷ�Y"  .. i];
            WAR.Person[WAR.PersonNum]["����"]=false;
            WAR.Person[WAR.PersonNum]["�˷���"]=2;
            WAR.PersonNum=WAR.PersonNum+1;
		end
    end
	if WAR.PersonNum>0 then
	    return ;
    end

    for i=1,CC.TeamNum do                 --��������ȷ���Ĳ�ս��
        WAR.SelectPerson[i]=0;
        local id=JY.Base["����" .. i];
        if id>=0 then
            for j=1,6 do
                if WAR.Data["�ֶ�ѡ���ս��" .. j]==id then
                    WAR.SelectPerson[i]=1;
                end
            end
        end
    end

    local menu={};
    for i=1, CC.TeamNum do
        menu[i]={"",WarSelectMenu,0};
        local id=JY.Base["����" .. i];
        if id>=0 then
            menu[i][3]=1;
            local s=JY.Person[id]["����"];
            if WAR.SelectPerson[i]==1 then
                menu[i][1]="*" .. s;
            else
                menu[i][1]=" " .. s;
            end
        end
    end

    menu[CC.TeamNum+1]={" ����",nil,1}

	while true do
		Cls();
		local x=(CC.ScreenW-7*CC.DefaultFont-2*CC.MenuBorderPixel)/2;
		DrawStrBox(x,10,"��ѡ���ս����",C_WHITE,CC.DefaultFont);
		local r=ShowMenu(menu,CC.TeamNum+1,0,x,10+CC.SingleLineHeight,0,0,1,0,CC.DefaultFont,C_ORANGE,C_WHITE);
		Cls();

		for i=1,6 do
			if WAR.SelectPerson[i]>0 then
				WAR.Person[WAR.PersonNum]["������"]=JY.Base["����" ..i];
				WAR.Person[WAR.PersonNum]["�ҷ�"]=true;
				WAR.Person[WAR.PersonNum]["����X"]=WAR.Data["�ҷ�X"  .. i];
				WAR.Person[WAR.PersonNum]["����Y"]=WAR.Data["�ҷ�Y"  .. i];
				WAR.Person[WAR.PersonNum]["����"]=false;
				WAR.Person[WAR.PersonNum]["�˷���"]=2;
				WAR.PersonNum=WAR.PersonNum+1;
			end
		end
		if WAR.PersonNum>0 then   --ѡ�����ҷ���ս��
		   break;
		end
    end
end


--ѡ��ս���˲˵����ú���
function WarSelectMenu(newmenu,newid)            --ѡ��ս���˲˵����ú���
    local id=newmenu[newid][4];

    if WAR.SelectPerson[id]==0 then
        WAR.SelectPerson[id]=2;
    elseif WAR.SelectPerson[id]==2 then
        WAR.SelectPerson[id]=0;
    end

    if WAR.SelectPerson[id]>0 then
        newmenu[newid][1]="*" .. string.sub(newmenu[newid][1],2);
    else
        newmenu[newid][1]=" " .. string.sub(newmenu[newid][1],2);
    end
    return 0;
end

--ѡ��з���ս��
function WarSelectEnemy()            --ѡ��з���ս��
    for i=1,20 do
        if WAR.Data["����"  .. i]>0 then
            WAR.Person[WAR.PersonNum]["������"]=WAR.Data["����"  .. i];
            WAR.Person[WAR.PersonNum]["�ҷ�"]=false;
            WAR.Person[WAR.PersonNum]["����X"]=WAR.Data["�з�X"  .. i];
            WAR.Person[WAR.PersonNum]["����Y"]=WAR.Data["�з�Y"  .. i];
            WAR.Person[WAR.PersonNum]["����"]=false;
            WAR.Person[WAR.PersonNum]["�˷���"]=1;
            WAR.PersonNum=WAR.PersonNum+1;
        end
    end
end

--����ս����ͼ
--��6�㣬�����˹����õ�ͼ
--        0�� ��������
--        1�� ����
--����Ϊս����ͼ���ݣ���ս���ļ������롣����Ϊ�����õĵ�ͼ�ṹ
--        2�� ս����ս����ţ���WAR.Person�ı��
--        3�� �ƶ�ʱ��ʾ���ƶ���λ��
--        4�� ����Ч��
--        5�� ս���˶�Ӧ����ͼ

function WarLoadMap(mapid)      --����ս����ͼ
   lib.Debug(string.format("load war map %d",mapid));
   lib.LoadWarMap(CC.WarMapFile[1],CC.WarMapFile[2],mapid,6,CC.WarWidth,CC.WarHeight);
end

function GetWarMap(x,y,level)   --ȡս����ͼ����
     return lib.GetWarMap(x,y,level);
end

function SetWarMap(x,y,level,v)  --��ս����ͼ����
 	lib.SetWarMap(x,y,level,v);
end

--����ĳ��Ϊ����ֵ
function CleanWarMap(level,v)
	lib.CleanWarMap(level,v);
end


--��ս����ͼ
--flag==0 ����
--      1 ��ʾ�ƶ�·�� (v1,v2) ��ǰ�ƶ�λ��
--      2 ��������书��ҽ�Ƶȣ���һ����ɫ��ʾ
--      4 ս������, v1 ս������pic, v2ս��������ͼ����(0 ʹ��ս��������ͼ��4��fight***��ͼ��� v3 �书Ч����ͼ -1û��Ч��

function WarDrawMap(flag,v1,v2,v3)
    local x=WAR.Person[WAR.CurID]["����X"];
    local y=WAR.Person[WAR.CurID]["����Y"];

    if flag==0 then
	    lib.DrawWarMap(0,x,y,0,0,-1);
    elseif flag==1 then
		if WAR.Data["��ͼ"]==0 then     --ѩ�ص�ͼ�ú�ɫ����
		    lib.DrawWarMap(1,x,y,v1,v2,-1);
        else
		    lib.DrawWarMap(2,x,y,v1,v2,-1);
		end
	elseif flag==2 then
	    lib.DrawWarMap(3,x,y,0,0,-1);
	elseif flag==4 then
	    lib.DrawWarMap(4,x,y,v1,v2,v3);
	end
	if WAR.ShowHead==1 then
        WarShowHead();
	end
end


function WarPersonSort()               --ս�����ﰴ�Ṧ����
    for i=0,WAR.PersonNum-1 do                ---������˵��Ṧ������װ���ӳ�
        local id=WAR.Person[i]["������"];
        local add=0;
        if JY.Person[id]["����"]>-1 then
            add=add+JY.Thing[JY.Person[id]["����"]]["���Ṧ"];
        end
        if JY.Person[id]["����"]>-1 then
            add=add+JY.Thing[JY.Person[id]["����"]]["���Ṧ"];
        end
        WAR.Person[i]["�Ṧ"]=JY.Person[id]["�Ṧ"]+add;
        local move=math.modf(WAR.Person[i]["�Ṧ"]/15)-math.modf(JY.Person[id]["���˳̶�"]/40);
        if move<0 then
            move=0;
        end
        WAR.Person[i]["�ƶ�����"]=move;
    end

    --���Ṧ�����ñȽϱ��ķ���
    for i=0,WAR.PersonNum-2 do
        local maxid=i;
        for j=i,WAR.PersonNum-1 do
            if WAR.Person[j]["�Ṧ"]>WAR.Person[maxid]["�Ṧ"] then
                maxid=j;
            end
        end
        WAR.Person[maxid],WAR.Person[i]=WAR.Person[i],WAR.Person[maxid];
    end
end

--����ս������λ�ú���ͼ
function WarSetPerson()            --����ս������λ��
 	CleanWarMap(2,-1);
 	CleanWarMap(5,-1);

	for i=0,WAR.PersonNum-1 do
        if WAR.Person[i]["����"]==false then
            SetWarMap(WAR.Person[i]["����X"],WAR.Person[i]["����Y"],2,i);
            SetWarMap(WAR.Person[i]["����X"],WAR.Person[i]["����Y"],5,WAR.Person[i]["��ͼ"]);
        end
    end
end


function WarCalPersonPic(id)       --����ս��������ͼ
    local n=5106;            --ս��������ͼ��ʼλ��
    n=n+JY.Person[WAR.Person[id]["������"]]["ͷ�����"]*8+WAR.Person[id]["�˷���"]*2;
    return n;
end

-------------------------------------------------------------------------------------------
---------------------------------����Ϊ�ֶ�ս������-------------------------------------------
-------------------------------------------------------------------------------------------

--�ֶ�ս��
--id ս��������
--���أ�ѡ�в˵���ţ�ѡ��"�ȴ�"ʱ��Ч��
function War_Manual()        --�ֶ�ս��
    local r;
	while true do
	    WAR.ShowHead=1;          --��ʾͷ��
	    r=War_Manual_Sub();  --�ֶ�ս���˵�
        if math.abs(r)~=1 then        --�ƶ���Ϻ��������ɲ˵�
		    break;
		end
	end
	WAR.ShowHead=0;
	return r;
end


function War_Manual_Sub()                --�ֶ�ս���˵�
    local pid=WAR.Person[WAR.CurID]["������"];
    local menu={ {"�ƶ�",War_MoveMenu,1},
                 {"����",War_FightMenu,1},
                 {"�ö�",War_PoisonMenu,1},
                 {"�ⶾ",War_DecPoisonMenu,1},
                 {"ҽ��",War_DoctorMenu,1},
                 {"��Ʒ",War_ThingMenu,1},
                 {"�ȴ�",War_WaitMenu,1},
                 {"״̬",War_StatusMenu,1},
                 {"��Ϣ",War_RestMenu,1},
                 {"�Զ�",War_AutoMenu,1},   };

    if JY.Person[pid]["����"]<=5 or WAR.Person[WAR.CurID]["�ƶ�����"]<=0 then  --�����ƶ�
        menu[1][3]=0;
    end

    local minv=War_GetMinNeiLi(pid);

    if JY.Person[pid]["����"] < minv or JY.Person[pid]["����"] <10 then  --����ս��
        menu[2][3]=0;
    end

    if JY.Person[pid]["����"]<10 or JY.Person[pid]["�ö�����"]<20 then  --�����ö�
        menu[3][3]=0;
    end

    if JY.Person[pid]["����"]<10 or JY.Person[pid]["�ⶾ����"]<20 then  --���ܽⶾ
        menu[4][3]=0;
    end

    if JY.Person[pid]["����"]<50 or JY.Person[pid]["ҽ������"]<20 then  --����ҽ��
        menu[5][3]=0;
    end

    lib.GetKey();
    Cls();
    return ShowMenu(menu,10,0,CC.MainMenuX,CC.MainMenuY,0,0,1,0,CC.DefaultFont,C_ORANGE,C_WHITE);

end


function War_GetMinNeiLi(pid)       --���������书����Ҫ�������ٵ�
    local minv=math.huge;
    for i=1,10 do
        local tmpid=JY.Person[pid]["�书" .. i];
        if tmpid >0 then
            if JY.Wugong[tmpid]["������������"]< minv then
                minv=JY.Wugong[tmpid]["������������"];
            end
        end
    end
	return minv;
end

function WarShowHead()               --��ʾս����ͷ��
    local pid=WAR.Person[WAR.CurID]["������"];
	local p=JY.Person[pid];

	local h=16+2;
    local width=112+2*CC.MenuBorderPixel;
	local height=100+2*CC.MenuBorderPixel+4*h;
	local x1,y1;
	local i=1;
    if WAR.Person[WAR.CurID]["�ҷ�"]==true then
	    x1=CC.ScreenW-width-10;
        y1=CC.ScreenH-height-10;
    else
	    x1=10;
        y1=10;
    end

    DrawBox(x1,y1,x1+width,y1+height,C_WHITE);
	local headw,headh=lib.PicGetXY(1,p["ͷ�����"]*2);
    local headx=(100-headw)/2;
	local heady=(100-headh)/2;

	lib.PicLoadCache(1,p["ͷ�����"]*2,x1+5+headx,y1+5+heady,1);
	x1=x1+5
	y1=y1+5+100;

    DrawString(x1,y1,p["����"],C_WHITE,16);

    local color;              --��ʾ���������ֵ���������˺��ж���ʾ��ͬ��ɫ
    if p["���˳̶�"]<33 then
        color =RGB(236,200,40);
    elseif p["���˳̶�"]<66 then
        color=RGB(244,128,32);
    else
        color=RGB(232,32,44);
    end
    DrawString(x1,y1+h,"����",C_ORANGE,16);
    DrawString(x1+40,y1+h,string.format("%4d",p["����"]),color,16);
    DrawString(x1+40+32,y1+h,"/",C_GOLD,16);
    if p["�ж��̶�"]==0 then
        color =RGB(252,148,16);
    elseif p["�ж��̶�"]<50 then
        color=RGB(120,208,88);
    else
        color=RGB(56,136,36);
    end
    DrawString(x1+40+40,y1+h,string.format("%4d",p["�������ֵ"]),color,16);

                  --��ʾ���������ֵ����������������ʾ��ͬ��ɫ
    if p["��������"]==0 then
        color=RGB(208,152,208);
    elseif p["��������"]==1 then
        color=RGB(236,200,40);
    else
        color=RGB(236,236,236);
    end
    DrawString(x1,y1+h*2,"����",C_ORANGE,16);
    DrawString(x1+40,y1+h*2,string.format("%4d/%4d",p["����"],p["�������ֵ"]),color,16);

	DrawString(x1,y1+h*3,"����",C_ORANGE,16);
	DrawString(x1+40,y1+h*3,string.format("%4d",p["����"]),C_GOLD,16);
end


--����1���Ѿ��ƶ�    0 û���ƶ�
function War_MoveMenu()           --ִ���ƶ��˵�
    WAR.ShowHead=0;   --����ʾͷ��
    if WAR.Person[WAR.CurID]["�ƶ�����"]<=0 then
        return 0;
    end

    War_CalMoveStep(WAR.CurID,WAR.Person[WAR.CurID]["�ƶ�����"],0);   --�����ƶ�����

    local r;
    local x,y=War_SelectMove()             --ѡ���ƶ�λ��
    if x ~=nil then            --��ֵ��ʾû��ѡ��esc�����ˣ��ǿ����ʾѡ����λ��
        War_MovePerson(x,y);    --�ƶ�����Ӧ��λ��
        r=1;
	else
	    r=0
		WAR.ShowHead=1;
		Cls();
    end
    lib.GetKey();
    return r;
end

--������ƶ�����
--id ս����id��
--stepmax �������
--flag=0  �ƶ�����Ʒ�����ƹ���1 �书���ö�ҽ�Ƶȣ������ǵ�·��
function War_CalMoveStep(id,stepmax,flag)                   --������ƶ�����

  	CleanWarMap(3,255);           --�������������������ƶ����ȶ���Ϊ255��

    local x=WAR.Person[id]["����X"];
    local y=WAR.Person[id]["����Y"];

	local steparray={};     --�����鱣���n�������ꡣ
	for i=0,stepmax do
	    steparray[i]={};
        steparray[i].x={};
        steparray[i].y={};
	end

	SetWarMap(x,y,3,0);
    steparray[0].num=1;
	steparray[0].x[1]=x;
	steparray[0].y[1]=y;
	for i=0,stepmax-1 do       --���ݵ�0���������ҳ���1����Ȼ�������
	    War_FindNextStep(steparray,i,flag);
		if steparray[i+1].num==0 then
		    break;
		end
    end

	return steparray;

end


function War_FindNextStep(steparray,step,flag)      --������һ�����ƶ�������
    local num=0;
	local step1=step+1;
	for i=1,steparray[step].num do
	    local x=steparray[step].x[i];
	    local y=steparray[step].y[i];
	    if x+1<CC.WarWidth-1 then                        --��ǰ���������ڸ�
		    local v=GetWarMap(x+1,y,3);
			if v ==255 and War_CanMoveXY(x+1,y,flag)==true then
                num= num+1;
                steparray[step1].x[num]=x+1;
                steparray[step1].y[num]=y;
				SetWarMap(x+1,y,3,step1);
			end
		end

	    if x-1>0 then                        --��ǰ���������ڸ�
		    local v=GetWarMap(x-1,y,3);
			if v ==255 and War_CanMoveXY(x-1,y,flag)==true then
                 num=num+1;
                steparray[step1].x[num]=x-1;
                steparray[step1].y[num]=y;
				SetWarMap(x-1,y,3,step1);
			end
		end

	    if y+1<CC.WarHeight-1 then                        --��ǰ���������ڸ�
		    local v=GetWarMap(x,y+1,3);
			if v ==255 and War_CanMoveXY(x,y+1,flag)==true then
                 num= num+1;
                steparray[step1].x[num]=x;
                steparray[step1].y[num]=y+1;
				SetWarMap(x,y+1,3,step1);
			end
		end

	    if y-1>0 then                        --��ǰ���������ڸ�
		    local v=GetWarMap(x ,y-1,3);
			if v ==255 and War_CanMoveXY(x,y-1,flag)==true then
                num= num+1;
                steparray[step1].x[num]=x ;
                steparray[step1].y[num]=y-1;
				SetWarMap(x ,y-1,3,step1);
			end
		end
	end
    steparray[step1].num=num;

end

function War_CanMoveXY(x,y,flag)  --�����Ƿ����ͨ�����ж��ƶ�ʱʹ��
	if GetWarMap(x,y,1)>0 then    --��1��������
		return false
	end
	if flag==0 then
		if CC.WarWater[GetWarMap(x,y,0)]~=nil then          --ˮ�棬������
			return false
		end
		if GetWarMap(x,y,2)>=0 then    --����
			return false
		end
	end
	return true;
end

function War_SelectMove()              ---ѡ���ƶ�λ��
    local x0=WAR.Person[WAR.CurID]["����X"];
    local y0=WAR.Person[WAR.CurID]["����Y"];
    local x=x0;
    local y=y0;

    while true do
        local x2=x;
        local y2=y;

        WarDrawMap(1,x,y);

        ShowScreen();
        local key=WaitKey();
        if key==VK_UP then
            y2=y-1;
        elseif key==VK_DOWN then
            y2=y+1;
        elseif key==VK_LEFT then
            x2=x-1;
        elseif key==VK_RIGHT then
            x2=x+1;
        elseif key==VK_SPACE or key==VK_RETURN then
            return x,y;
        elseif key==VK_ESCAPE then
            return nil;
        end

		if GetWarMap(x2,y2,3)<128 then
            x=x2;
            y=y2;
        end
    end

end


function War_MovePerson(x,y)            --�ƶ����ﵽλ��x,y

    local movenum=GetWarMap(x,y,3);
    WAR.Person[WAR.CurID]["�ƶ�����"]=WAR.Person[WAR.CurID]["�ƶ�����"]-movenum;    --���ƶ�������С

    local movetable={};  --   ��¼ÿ���ƶ�
    for i=movenum,1,-1 do    --��Ŀ��λ�÷����ҵ���ʼλ�ã���Ϊ�ƶ��Ĵ���
        movetable[i]={};
        movetable[i].x=x;
        movetable[i].y=y;
        if GetWarMap(x-1,y,3)==i-1 then
            x=x-1;
            movetable[i].direct=1;
        elseif GetWarMap(x+1,y,3)==i-1 then
            x=x+1;
            movetable[i].direct=2;
        elseif GetWarMap(x,y-1,3)==i-1 then
            y=y-1;
            movetable[i].direct=3;
        elseif GetWarMap(x,y+1,3)==i-1 then
            y=y+1;
            movetable[i].direct=0;
        end
    end

    for i=1,movenum do
        local t1=lib.GetTime();

		SetWarMap(WAR.Person[WAR.CurID]["����X"],WAR.Person[WAR.CurID]["����Y"],2,-1);
		SetWarMap(WAR.Person[WAR.CurID]["����X"],WAR.Person[WAR.CurID]["����Y"],5,-1);

        WAR.Person[WAR.CurID]["����X"]=movetable[i].x;
        WAR.Person[WAR.CurID]["����Y"]=movetable[i].y;
        WAR.Person[WAR.CurID]["�˷���"]=movetable[i].direct;
        WAR.Person[WAR.CurID]["��ͼ"]=WarCalPersonPic(WAR.CurID);

		SetWarMap(WAR.Person[WAR.CurID]["����X"],WAR.Person[WAR.CurID]["����Y"],2,WAR.CurID);
		SetWarMap(WAR.Person[WAR.CurID]["����X"],WAR.Person[WAR.CurID]["����Y"],5,WAR.Person[WAR.CurID]["��ͼ"]);

		WarDrawMap(0);
		ShowScreen();
        local t2=lib.GetTime();
		if i<movenum then
			if (t2-t1)< 2*CC.Frame then
				lib.Delay(2*CC.Frame-(t2-t1));
			end
		end
    end

end


function War_FightMenu()              --ִ�й����˵�
    local pid=WAR.Person[WAR.CurID]["������"];

    local numwugong=0;
    local menu={};
    for i=1,10 do
        local tmp=JY.Person[pid]["�书" .. i];
        if tmp>0 then
            menu[i]={JY.Wugong[tmp]["����"],nil,1};
            if JY.Wugong[tmp]["������������"] > JY.Person[pid]["����"] then
                menu[i][3]=0;
            end
            numwugong=numwugong+1;
        end
    end

    if numwugong==0 then
        return 0;
    end
    local r;
    if numwugong==1 then
        r=1;
    else
        r=ShowMenu(menu,numwugong,0,CC.MainSubMenuX,CC.MainSubMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE,C_WHITE);
    end
    if r==0 then
        return 0;
    end

    WAR.ShowHead=0;
    local r2=War_Fight_Sub(WAR.CurID,r);
    WAR.ShowHead=1;
	Cls();
	return r2;
end

--ִ��ս�����Զ����ֶ�ս��������
function War_Fight_Sub(id,wugongnum,x,y)          --ִ��ս��
    local pid=WAR.Person[id]["������"];
    local wugong=JY.Person[pid]["�书" .. wugongnum];
    local level=math.modf(JY.Person[pid]["�书�ȼ�" .. wugongnum]/100)+1;

   	CleanWarMap(4,0);

    local fightscope=JY.Wugong[wugong]["������Χ"];
	--��map4��ע�书����Ч��
    if fightscope==0 then
        if War_FightSelectType0(wugong,level,x,y)==false then
            return 0;
        end
    elseif fightscope==1 then
        War_FightSelectType1(wugong,level,x,y)

    elseif fightscope==2 then
        War_FightSelectType2(wugong,level,x,y)

    elseif fightscope==3 then
        if War_FightSelectType3(wugong,level,x,y)==false then
            return 0;
        end
    end

    local fightnum=1;
    if JY.Person[pid]["���һ���"]==1 then
        fightnum=2;
    end

for k=1,fightnum  do         --������һ������򹥻�����
    for i=0,CC.WarWidth-1 do
        for j=0,CC.WarHeight-1 do
			local effect=GetWarMap(i,j,4);
            if effect>0 then              --����Ч���ط�
  				local emeny=GetWarMap(i,j,2);
                 if emeny>=0 then          --����
                     if WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[emeny]["�ҷ�"] then       --�ǵ���
					     --ֻ�е���湥������ɱ��������ʱ�˺�������Ч
					     if JY.Wugong[wugong]["�˺�����"]==1 and (fightscope==0 or fightscope==3) then
                             WAR.Person[emeny]["����"]=-War_WugongHurtNeili(emeny,wugong,level)
							 SetWarMap(i,j,4,3);
							 WAR.Effect=3;
                         else
                             WAR.Person[emeny]["����"]=-War_WugongHurtLife(emeny,wugong,level)
							 WAR.Effect=2;
							 SetWarMap(i,j,4,2);
                         end
                     end
                 end
             end
         end
    end

    War_ShowFight(pid,wugong,JY.Wugong[wugong]["�书����"],level,x,y,JY.Wugong[wugong]["�书����&��Ч"]);

    for i=0,WAR.PersonNum-1 do
        WAR.Person[i]["����"]=0;
    end

    WAR.Person[WAR.CurID]["����"]=WAR.Person[WAR.CurID]["����"]+2;

    if JY.Person[pid]["�书�ȼ�" .. wugongnum]<900 then
        JY.Person[pid]["�书�ȼ�" .. wugongnum]=JY.Person[pid]["�书�ȼ�" .. wugongnum]+Rnd(2)+1;
    end

    if math.modf(JY.Person[pid]["�书�ȼ�" .. wugongnum]/100)+1 ~= level then    --�书������
        level=math.modf(JY.Person[pid]["�书�ȼ�" .. wugongnum]/100)+1;
        DrawStrBox(-1,-1,string.format("%s ��Ϊ %d ��",JY.Wugong[wugong]["����"],level),C_ORANGE,CC.DefaultFont)
        ShowScreen();
        lib.Delay(500);
        Cls();
        ShowScreen();
    end

    AddPersonAttrib(pid,"����",-math.modf((level+1)/2)*JY.Wugong[wugong]["������������"])

end

    AddPersonAttrib(pid,"����",-3);

    return 1;
end

--ѡ��㹥��
--x1,y1 �����㣬���Ϊ�����ֹ�ѡ��
function War_FightSelectType0(wugong,level,x1,y1)          --ѡ��㹥��
    local x0=WAR.Person[WAR.CurID]["����X"];
    local y0=WAR.Person[WAR.CurID]["����Y"];
    War_CalMoveStep(WAR.CurID,JY.Wugong[wugong]["�ƶ���Χ" .. level],1);

    if x1==nil and y1==nil then
        x1,y1=War_SelectMove();              --ѡ�񹥻�����
    end
    if x1 ==nil then
        lib.GetKey();
		Cls();
        return false;
    end

    WAR.Person[WAR.CurID]["�˷���"]=War_Direct(x0,y0,x1,y1);

	SetWarMap(x1,y1,4,1);

    WAR.EffectXY={};
	WAR.EffectXY[1]={x1,y1};
	WAR.EffectXY[2]={x1,y1};

end

--ѡ���߹���
--direct ��������Ϊ�����ֹ�����
function War_FightSelectType1(wugong,level,x,y)            --ѡ���߹���
    local x0=WAR.Person[WAR.CurID]["����X"];
    local y0=WAR.Person[WAR.CurID]["����Y"];
    local direct;

    if x==nil and y==nil  then
        direct =-1;
        DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"��ѡ�񹥻�����",C_ORANGE,CC.DefaultFont)
        ShowScreen();

        while true do           --ѡ����
            local key=WaitKey();
            if key==VK_UP then
                direct=0;
            elseif key==VK_DOWN then
                direct=3;
            elseif key==VK_LEFT then
                direct=2;
            elseif key==VK_RIGHT then
                direct=1;
            end
            if direct>=0 then
                break;
            end
        end

        Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
        ShowScreen();
    else
        direct=War_Direct(x0,y0,x,y);
    end

    WAR.Person[WAR.CurID]["�˷���"]=direct;
    local move=JY.Wugong[wugong]["�ƶ���Χ" .. level]

    WAR.EffectXY={};

    for i=1,move do
        if direct==0 then
            SetWarMap(x0,y0-i,4,1);
        elseif direct==3 then
            SetWarMap(x0,y0+i,4,1);
        elseif direct==2 then
            SetWarMap(x0-i,y0,4,1);
        elseif direct==1 then
            SetWarMap(x0+i,y0,4,1);
        end
    end

	if direct==0 then
		WAR.EffectXY[1]={x0,y0-1};
		WAR.EffectXY[2]={x0,y0-move};
	elseif direct==3 then
		WAR.EffectXY[1]={x0,y0+1};
		WAR.EffectXY[2]={x0,y0+move};
	elseif direct==2 then
		WAR.EffectXY[1]={x0-1,y0};
		WAR.EffectXY[2]={x0-move,y0};
	elseif direct==1 then
		WAR.EffectXY[1]={x0+1,y0};
		WAR.EffectXY[2]={x0+move,y0};
	end

end

--ѡ��ʮ�ֹ���
function War_FightSelectType2(wugong,level)                 --ѡ��ʮ�ֹ���
    local x0=WAR.Person[WAR.CurID]["����X"];
    local y0=WAR.Person[WAR.CurID]["����Y"];

    local move=JY.Wugong[wugong]["�ƶ���Χ" .. level]

    WAR.EffectXY={};

    for i=1,move do
        SetWarMap(x0,y0-i,4,1);
        SetWarMap(x0,y0+i,4,1);
		SetWarMap(x0-i,y0,4,1);
		SetWarMap(x0+i,y0,4,1);
    end

	WAR.EffectXY[1]={x0-move,y0};
	WAR.EffectXY[2]={x0+move,y0};

end

--ѡ���湥��
--x1,y1 �����㣬���Ϊ�����ֹ�ѡ��
function War_FightSelectType3(wugong,level,x1,y1)            --ѡ���湥��
    local x0=WAR.Person[WAR.CurID]["����X"];
    local y0=WAR.Person[WAR.CurID]["����Y"];
    War_CalMoveStep(WAR.CurID,JY.Wugong[wugong]["�ƶ���Χ" .. level],1);

    if x1==nil and y1==nil then
        x1,y1=War_SelectMove();              --ѡ�񹥻�����
    end

    if x1 ==nil then
        lib.GetKey();
		Cls();
        return false;
    end

    WAR.Person[WAR.CurID]["�˷���"]=War_Direct(x0,y0,x1,y1);

    local move=JY.Wugong[wugong]["ɱ�˷�Χ" .. level]

	WAR.EffectXY={};

    for i=-move,move do
        for j=-move,move do
			SetWarMap(x1+i,y1+j,4,1);
         end
    end

	WAR.EffectXY[1]={x1-2*move,y1};
	WAR.EffectXY[2]={x1+2*move,y1};
end

--�����˷���
--(x1,y1) ��λ��     -(x2,y2) Ŀ��λ��
--���أ� ����
function War_Direct(x1,y1,x2,y2)             --�����˷���
    local x=x2-x1;
    local y=y2-y1;

    if math.abs(y)>math.abs(x) then
        if y>0 then
            return 3;
        else
            return 0
        end
    else
        if x>0 then
            return 1;
        else
            return 2;
        end
    end
end


--��ʾս������
--pid ��id
--wugong  �书��ţ� 0 ��ʾ�ö��ⶾ�ȣ�ʹ����ͨ����Ч��
--wogongtype =0 ҽ���ö��ⶾ��1,2,3,4 �书����  -1 ����
--level �书�ȼ�
--x,y ��������
--eft  �书����Ч��id  eft.idx/grp�е�Ч��

function War_ShowFight(pid,wugong,wugongtype,level,x,y,eft)              --��ʾս������

	local x0=WAR.Person[WAR.CurID]["����X"];
	local y0=WAR.Person[WAR.CurID]["����Y"];

    local fightdelay,fightframe,sounddelay;
    if wugongtype>=0 then
        fightdelay=JY.Person[pid]["���ж����ӳ�" .. wugongtype+1];
        fightframe=JY.Person[pid]["���ж���֡��" .. wugongtype+1];
        sounddelay=JY.Person[pid]["�书��Ч�ӳ�" .. wugongtype+1];
    else            ---��������Щ����ʲô��˼����
        fightdelay=0;
        fightframe=-1;
        sounddelay=-1;
    end

    local framenum=fightdelay+CC.Effect[eft];            --��֡��

    local startframe=0;               --����fignt***�е�ǰ������ʼ֡
    if wugongtype>=0 then
        for i=0,wugongtype-1 do
            startframe=startframe+4*JY.Person[pid]["���ж���֡��" .. i+1];
        end
    end

    local starteft=0;          --������ʼ�书Ч��֡
    for i=0,eft-1 do
        starteft=starteft+CC.Effect[i];
    end

	WAR.Person[WAR.CurID]["��ͼ����"]=0;
	WAR.Person[WAR.CurID]["��ͼ"]=WarCalPersonPic(WAR.CurID);

    WarSetPerson();

	WarDrawMap(0);
	ShowScreen();

    local fastdraw;
    if CONFIG.FastShowScreen==0 or CC.AutoWarShowHead==1 then    --��ʾͷ����ȫ���ػ�
        fastdraw=0;
	else
	    fastdraw=1;
	end

    --����ʾ����ǰ�ȼ�����ͼ
    local oldpic=WAR.Person[WAR.CurID]["��ͼ"]/2;
	local oldpic_type=0;

    local oldeft=-1;

    for i=0,framenum-1 do
        local tstart=lib.GetTime();
		local mytype;
        if fightframe>0 then
            WAR.Person[WAR.CurID]["��ͼ����"]=1;
		    mytype=4+WAR.CurID;
            if i<fightframe then
                WAR.Person[WAR.CurID]["��ͼ"]=(startframe+WAR.Person[WAR.CurID]["�˷���"]*fightframe+i)*2;
            end
        else       --��������ʹ��fight��ͼ��
            WAR.Person[WAR.CurID]["��ͼ����"]=0;
            WAR.Person[WAR.CurID]["��ͼ"]=WarCalPersonPic(WAR.CurID);
			mytype=0;
        end

        if i==sounddelay then
            PlayWavAtk(JY.Wugong[wugong]["������Ч"]);
        end
        if i==fightdelay then
            PlayWavE(eft);
        end
		local pic=WAR.Person[WAR.CurID]["��ͼ"]/2;
		if fastdraw==1 then
			local rr=ClipRect(Cal_PicClip(0,0,oldpic,oldpic_type,0,0,pic,mytype));
			if rr ~=nil then
				lib.SetClip(rr.x1,rr.y1,rr.x2,rr.y2);
			end
		else
			lib.SetClip(0,0,0,0);
		end
		oldpic=pic;
		oldpic_type=mytype;

		if i<fightdelay then   --ֻ��ʾ����
		    WarDrawMap(4,pic*2,mytype,-1);
		else		--ͬʱ��ʾ�书Ч��
            starteft=starteft+1;            --�˴��ƺ���eft��һ�����������⣬Ӧ����10����Ϊ9����˼�1

			if fastdraw==1 then
				local clip1={};
				clip1=Cal_PicClip(WAR.EffectXY[1][1]-x0,WAR.EffectXY[1][2]-y0,oldeft,3,
										WAR.EffectXY[1][1]-x0,WAR.EffectXY[1][2]-y0,starteft,3);
				local clip2={};
				clip2=Cal_PicClip(WAR.EffectXY[2][1]-x0,WAR.EffectXY[2][2]-y0,oldeft,3,
										WAR.EffectXY[2][1]-x0,WAR.EffectXY[2][2]-y0,starteft,3);
				local clip=ClipRect(MergeRect(clip1,clip2));

				if clip ~=nil then
					local area=(clip.x2-clip.x1)*(clip.y2-clip.y1);          --������������
					if area <CC.ScreenW*CC.ScreenH/2 then        --����㹻С�����������Ρ�
						WarDrawMap(4,pic*2,mytype,starteft*2);
						lib.SetClip(clip.x1,clip.y1,clip.x2,clip.y2);
						WarDrawMap(4,pic*2,mytype,starteft*2);
					else    --���̫��ֱ���ػ�
						lib.SetClip(0,0,CC.ScreenW,CC.ScreenH);
						WarDrawMap(4,pic*2,mytype,starteft*2);
					end
				else
				    WarDrawMap(4,pic*2,mytype,starteft*2);
				end
			else
				lib.SetClip(0,0,0,0);
				WarDrawMap(4,pic*2,mytype,starteft*2);
			end
			oldeft=starteft;
		end

		ShowScreen(fastdraw);
        lib.SetClip(0,0,0,0);

		local tend=lib.GetTime();
    	if tend-tstart<1*CC.Frame then
            lib.Delay(1*CC.Frame-(tend-tstart));
	    end

    end

	lib.SetClip(0,0,0,0);
    WAR.Person[WAR.CurID]["��ͼ����"]=0;
    WAR.Person[WAR.CurID]["��ͼ"]=WarCalPersonPic(WAR.CurID);
    WarSetPerson();
    WarDrawMap(0);

    ShowScreen();
    lib.Delay(200);

    WarDrawMap(2);          --ȫ����ʾ��������
    ShowScreen();
    lib.Delay(200);

    WarDrawMap(0);
    ShowScreen();

    local HitXY={};               --��¼���е���������
	local HitXYNum=0;
    for i = 0, WAR.PersonNum-1 do
	    local x1=WAR.Person[i]["����X"];
	    local y1=WAR.Person[i]["����Y"];
		if WAR.Person[i]["����"]==false then
 		    if GetWarMap(x1,y1,4)>1 then
			    local n=WAR.Person[i]["����"]
				HitXY[HitXYNum]={x1,y1,string.format("%+d",n)};
				HitXYNum=HitXYNum+1;
 		    end
		end
	end

if HitXYNum>0 then
	local clips={};                --�������е���clip
	for i=0,HitXYNum-1 do
		local dx=HitXY[i][1]-x0;
		local dy=HitXY[i][2]-y0;
		local ll=string.len(HitXY[i][3]);
		local w=ll*CC.DefaultFont/2+1;
		clips[i]={x1=CC.XScale*(dx-dy)+CC.ScreenW/2,
				 y1=CC.YScale*(dx+dy)+CC.ScreenH/2,
				 x2=CC.XScale*(dx-dy)+CC.ScreenW/2+w,
				 y2=CC.YScale*(dx+dy)+CC.ScreenH/2+CC.DefaultFont+1 };
	end

    local clip=clips[0];

	for i=1,HitXYNum-1 do
	    clip=MergeRect(clip,clips[i]);
	end

	local area=(clip.x2-clip.x1)*(clip.y2-clip.y1)

    for i=1,15 do           --��ʾ���еĵ���
	    local tstart=lib.GetTime();
        local y_off=i*2+65;
        if fastdraw==1 and area <CC.ScreenW*CC.ScreenH/2 then
			local tmpclip={x1=clip.x1, y1=clip.y1-y_off, x2=clip.x2, y2=clip.y2-y_off};
			tmpclip=ClipRect(tmpclip);
			if tmpclip~=nil then
				lib.SetClip(tmpclip.x1,tmpclip.y1,tmpclip.x2,tmpclip.y2);
				WarDrawMap(0)
				for j=0,HitXYNum-1 do
					DrawString(clips[j].x1, clips[j].y1-y_off, HitXY[j][3],
							   WAR.EffectColor[WAR.Effect],CC.DefaultFont)
				end
			end
		else    --���̫��ֱ���ػ�
			lib.SetClip(0,0,CC.ScreenW,CC.ScreenH);
			WarDrawMap(0)
			for j=0,HitXYNum-1 do
				    DrawString(clips[j].x1, clips[j].y1-y_off, HitXY[j][3],
 			                   WAR.EffectColor[WAR.Effect],CC.DefaultFont)
			end
		end

		ShowScreen(1);
		lib.SetClip(0,0,0,0);

        local tend=lib.GetTime();
		if (tend-tstart)<CC.Frame then
	        lib.Delay(CC.Frame-(tend-tstart));
		end
    end
end

    lib.SetClip(0,0,0,0);
    WarDrawMap(0);
    ShowScreen();
end

--�书�˺�����
--enemyid ����ս��id��
--wugong  �ҷ�ʹ���书
--���أ��˺�����
function War_WugongHurtLife(emenyid,wugong,level)             --�����书�˺�����
    local pid=WAR.Person[WAR.CurID]["������"];
    local eid=WAR.Person[emenyid]["������"];

    --������ѧ��ʶ
    local mywuxue=0;
    local emenywuxue=0;
    for i=0,WAR.PersonNum-1 do
        local id =WAR.Person[i]["������"]
        if WAR.Person[i]["����"]==false and JY.Person[id]["��ѧ��ʶ"]>80 then
            if WAR.Person[WAR.CurID]["�ҷ�"]==WAR.Person[i]["�ҷ�"] then
                mywuxue=mywuxue+JY.Person[id]["��ѧ��ʶ"];
            else
                emenywuxue=emenywuxue+JY.Person[id]["��ѧ��ʶ"];
            end
        end
    end

    --����ʵ��ʹ���书�ȼ�
    while true do
        if math.modf((level+1)/2)*JY.Wugong[wugong]["������������"] > JY.Person[pid]["����"] then
            level=level-1;
        else
            break;
        end
    end

    if level<=0 then     --��ֹ�������һ���ʱ��һ�ι�����ϣ��ڶ��ι���û�������������
	    level=1;
    end

    --�书����������ӹ�����
    local fightnum=0;
    for i,v in ipairs(CC.ExtraOffense) do
        if v[1]==JY.Person[pid]["����"] and v[2]==wugong then
            fightnum=v[3];
            break;
        end
    end

    --���㹥����
    fightnum=fightnum+(JY.Person[pid]["������"]*3+JY.Wugong[wugong]["������" .. level ])/2;

    if JY.Person[pid]["����"]>=0 then
        fightnum=fightnum+JY.Thing[JY.Person[pid]["����"]]["�ӹ�����"];
    end
    if JY.Person[pid]["����"]>=0 then
        fightnum=fightnum+JY.Thing[JY.Person[pid]["����"]]["�ӹ�����"];
    end
    fightnum=fightnum+mywuxue;

    --���������
    local defencenum=JY.Person[eid]["������"];
    if JY.Person[eid]["����"]>=0 then
        defencenum=defencenum+JY.Thing[JY.Person[eid]["����"]]["�ӷ�����"];
    end
    if JY.Person[eid]["����"]>=0 then
        defencenum=defencenum+JY.Thing[JY.Person[eid]["����"]]["�ӷ�����"];
    end
    defencenum= defencenum+ emenywuxue;

    --����ʵ���˺�
    local hurt=(fightnum-3*defencenum)*2/3+Rnd(20)-Rnd(20);
    if hurt <0 then
        hurt=Rnd(10)+1;
    end
    hurt=hurt+JY.Person[pid]["����"]/15+JY.Person[eid]["���˳̶�"]/20;

    --���Ǿ�������
    local offset=math.abs(WAR.Person[WAR.CurID]["����X"]-WAR.Person[emenyid]["����X"])+
                 math.abs(WAR.Person[WAR.CurID]["����Y"]-WAR.Person[emenyid]["����Y"]);

    if offset <10 then
        hurt=hurt*(100-(offset-1)*3)/100;
    else
        hurt=hurt*2/3;
    end

    hurt=math.modf(hurt);
    if hurt<=0 then
        hurt=Rnd(8)+1;
    end

    JY.Person[eid]["����"]=JY.Person[eid]["����"]-hurt;
    WAR.Person[WAR.CurID]["����"]=WAR.Person[WAR.CurID]["����"]+math.modf(hurt/5);

    if JY.Person[eid]["����"]<0 then                 --�������˻�ö��⾭��
        JY.Person[eid]["����"]=0;
        WAR.Person[WAR.CurID]["����"]=WAR.Person[WAR.CurID]["����"]+JY.Person[eid]["�ȼ�"]*10;
    end

    AddPersonAttrib(eid,"���˳̶�",math.modf(hurt/10));

    --�����ж�����
    local poisonnum=level*JY.Wugong[wugong]["�����ж�����"]+JY.Person[pid]["��������"];

    if JY.Person[eid]["��������"]< poisonnum and JY.Person[eid]["��������"]<90 then
         AddPersonAttrib(eid,"�ж��̶�",math.modf(poisonnum/15));
    end

    return hurt;
end

--�书�˺�����
--enemyid ����ս��id��
--wugong  �ҷ�ʹ���书
--���أ��˺�����
function War_WugongHurtNeili(enemyid,wugong,level)           --�����书�˺�����
    local pid=WAR.Person[WAR.CurID]["������"];
    local eid=WAR.Person[enemyid]["������"];

    local addvalue=JY.Wugong[wugong]["������" .. level];
    local decvalue=JY.Wugong[wugong]["ɱ����" .. level];

    if addvalue>0 then
	    if math.modf(addvalue/2)>0 then
            AddPersonAttrib(pid,"�������ֵ",Rnd(math.modf(addvalue/2)));
		end
        AddPersonAttrib(pid,"����",math.abs(addvalue+Rnd(3)-Rnd(3)));
	end
    return -AddPersonAttrib(eid,"����",-math.abs(decvalue+Rnd(3)-Rnd(3)));
end

---�ö��˵�
function War_PoisonMenu()              ---�ö��˵�
    WAR.ShowHead=0;
    local r=War_ExecuteMenu(1);
	WAR.ShowHead=1;
	Cls();
	return r;
end

--��������ж�����
--pid ʹ���ˣ�
--emenyid  �ж���
function War_PoisonHurt(pid,emenyid)     --��������ж�����
    local v=math.modf((JY.Person[pid]["�ö�����"]-JY.Person[emenyid]["��������"])/4);
    if v<0 then
        v=0;
    end
    return AddPersonAttrib(emenyid,"�ж��̶�",v);
end

---�ⶾ�˵�
function War_DecPoisonMenu()          ---�ⶾ�˵�
    WAR.ShowHead=0;
    local r=War_ExecuteMenu(2);
	WAR.ShowHead=1;
	Cls();
	return r;
end

---ҽ�Ʋ˵�
function War_DoctorMenu()            ---ҽ�Ʋ˵�
    WAR.ShowHead=0;
    local r=War_ExecuteMenu(3);
	WAR.ShowHead=1;
	Cls();
	return r;
end

---ִ��ҽ�ƣ��ⶾ�ö�
---flag=1 �ö��� 2 �ⶾ��3 ҽ�� 4 ����
---thingid ������Ʒid
function War_ExecuteMenu(flag,thingid)            ---ִ��ҽ�ƣ��ⶾ�ö�����
    local pid=WAR.Person[WAR.CurID]["������"];
    local step;

    if flag==1 then
        step=math.modf(JY.Person[pid]["�ö�����"]/15)+1;         --�ö�����
    elseif flag==2 then
        step=math.modf(JY.Person[pid]["�ⶾ����"]/15)+1;         --�ⶾ����
    elseif flag==3 then
        step=math.modf(JY.Person[pid]["ҽ������"]/15)+1;         --ҽ�Ʋ���
    elseif flag==4 then
        step=math.modf(JY.Person[pid]["��������"]/15)+1;         --��������
    end

    War_CalMoveStep(WAR.CurID,step,1);

    local x1,y1=War_SelectMove();              --ѡ�񹥻�����

    if x1 ==nil then
        lib.GetKey();
		Cls();
        return 0;
    else
        return War_ExecuteMenu_Sub(x1,y1,flag,thingid);
    end
end


function War_ExecuteMenu_Sub(x1,y1,flag,thingid)     ---ִ��ҽ�ƣ��ⶾ�ö��������Ӻ������Զ�ҽ��Ҳ�ɵ���
    local pid=WAR.Person[WAR.CurID]["������"];
    local x0=WAR.Person[WAR.CurID]["����X"];
    local y0=WAR.Person[WAR.CurID]["����Y"];

    CleanWarMap(4,0);

	WAR.Person[WAR.CurID]["�˷���"]=War_Direct(x0,y0,x1,y1);

	SetWarMap(x1,y1,4,1);

    local emeny=GetWarMap(x1,y1,2);
	if emeny>=0 then          --����
		 if flag==1 then
			 if WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[emeny]["�ҷ�"] then       --�ǵ���
				 WAR.Person[emeny]["����"]=War_PoisonHurt(pid,WAR.Person[emeny]["������"])
				 SetWarMap(x1,y1,4,5);
  			     WAR.Effect=5;
			 end
		 elseif flag==2 then
			 if WAR.Person[WAR.CurID]["�ҷ�"] == WAR.Person[emeny]["�ҷ�"] then       --���ǵ���
				 WAR.Person[emeny]["����"]=ExecDecPoison(pid,WAR.Person[emeny]["������"])
				 SetWarMap(x1,y1,4,6);
  			     WAR.Effect=6;
			 end
		 elseif flag==3 then
			 if WAR.Person[WAR.CurID]["�ҷ�"] == WAR.Person[emeny]["�ҷ�"] then       --���ǵ���
				 WAR.Person[emeny]["����"]=ExecDoctor(pid,WAR.Person[emeny]["������"])
				 SetWarMap(x1,y1,4,4);
  			     WAR.Effect=4;
			 end
		 elseif flag==4 then
			 if WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[emeny]["�ҷ�"] then       --�ǵ���
				 WAR.Person[emeny]["����"]=War_AnqiHurt(pid,WAR.Person[emeny]["������"],thingid)
				 SetWarMap(x1,y1,4,2);
  			     WAR.Effect=2;
			 end
		 end

	end

    WAR.EffectXY={};
	WAR.EffectXY[1]={x1,y1};
	WAR.EffectXY[2]={x1,y1};

	if flag==1 then
		War_ShowFight(pid,0,0,0,x1,y1,30);
	elseif flag==2 then
		War_ShowFight(pid,0,0,0,x1,y1,36);
	elseif flag==3 then
		War_ShowFight(pid,0,0,0,x1,y1,0);
	elseif flag==4 then
		if emeny>=0 then
			War_ShowFight(pid,0,-1,0,x1,y1,JY.Thing[thingid]["�����������"]);
		end
	end

	for i=0,WAR.PersonNum-1 do
		WAR.Person[i]["����"]=0;
	end
	if flag==4 then
		if emeny>=0 then
			instruct_32(thingid,-1);            --��Ʒ��������
			return 1;
		else
			return 0;                   --������գ������û�д�
		end
	else
		WAR.Person[WAR.CurID]["����"]=WAR.Person[WAR.CurID]["����"]+1;
		AddPersonAttrib(pid,"����",-2);
	end

	return 1;

end


--��Ʒ�˵�
function War_ThingMenu()            --ս����Ʒ�˵�
    WAR.ShowHead=0;
    local thing={};
    local thingnum={};

    for i = 0,CC.MyThingNum-1 do
        thing[i]=-1;
        thingnum[i]=0;
    end

    local num=0;
    for i = 0,CC.MyThingNum-1 do
        local id = JY.Base["��Ʒ" .. i+1];
        if id>=0 then
            if JY.Thing[id]["����"]==3 or JY.Thing[id]["����"]==4 then
                thing[num]=id;
                thingnum[num]=JY.Base["��Ʒ����" ..i+1];
                num=num+1;
            end
        end
    end

    local r=SelectThing(thing,thingnum);
	Cls();
	local rr=0;
    if r>=0 then
        if UseThing(r)==1 then
		    rr=1;
		end
    end
	WAR.ShowHead=1;
	Cls();
    return rr;
end


---ʹ�ð���
function War_UseAnqi(id)          ---ս��ʹ�ð���
    return War_ExecuteMenu(4,id);
end


function War_AnqiHurt(pid,emenyid,thingid)         --���㰵���˺�
    local num;
    if JY.Person[emenyid]["���˳̶�"]==0 then
        num=JY.Thing[thingid]["������"]/4-Rnd(5);
    elseif JY.Person[emenyid]["���˳̶�"]<=33 then
        num=JY.Thing[thingid]["������"]/3-Rnd(5);
    elseif JY.Person[emenyid]["���˳̶�"]<=66 then
        num=JY.Thing[thingid]["������"]/2-Rnd(5);
    else
        num=JY.Thing[thingid]["������"]/2-Rnd(5);
    end

    num=math.modf((num-JY.Person[pid]["��������"]*2)/3);
    AddPersonAttrib(emenyid,"���˳̶�",math.modf(-num/4));      --�˴���numΪ��ֵ

    local r=AddPersonAttrib(emenyid,"����",math.modf(num));

    if JY.Thing[thingid]["���ж��ⶾ"]>0 then
        num=math.modf((JY.Thing[thingid]["���ж��ⶾ"]+JY.Person[pid]["��������"])/2);
        num=num-JY.Person[emenyid]["��������"];
        num=limitX(num,0,CC.PersonAttribMax["�ö�����"]);
        AddPersonAttrib(emenyid,"�ж��̶�",num);
    end
    return r;
end

--��Ϣ
function War_RestMenu()           --��Ϣ
    local pid=WAR.Person[WAR.CurID]["������"];
    local v=3+Rnd(3);
    AddPersonAttrib(pid,"����",v);
    if JY.Person[pid]["����"]>30 then
        v=3+Rnd(math.modf(JY.Person[pid]["����"]/10)-2);
        AddPersonAttrib(pid,"����",v);
        v=3+Rnd(math.modf(JY.Person[pid]["����"]/10)-2);
        AddPersonAttrib(pid,"����",v);
    end
    return 1;
end


--�ȴ����ѵ�ǰս���˵�����β
function War_WaitMenu()            --�ȴ����ѵ�ǰս���˵�����β

    for i =WAR.CurID, WAR.PersonNum-2 do
        local tmp=WAR.Person[i+1];
        WAR.Person[i+1]=WAR.Person[i];
        WAR.Person[i]=tmp;
        --��������
    end

    WarSetPerson();     --����ս������λ��

    for i=0,WAR.PersonNum-1 do
        WAR.Person[i]["��ͼ"]=WarCalPersonPic(i);
    end

    return 1;

end



function War_StatusMenu()          --ս������ʾ״̬
    WAR.ShowHead=0;
	Menu_Status();
	WAR.ShowHead=1;
	Cls();
end

function War_AutoMenu()           --�����Զ�ս��
    WAR.AutoFight=1;
	WAR.ShowHead=0;
	Cls();
    War_Auto();
    return 1;
end

------------------------------------------------------------------------------------
-----------------------------------�Զ�ս��------------------------------------------



function War_Auto()             --�Զ�ս��������

	WAR.ShowHead=1;
	WarDrawMap(0);
	ShowScreen();
	lib.Delay(CC.WarAutoDelay);
	WAR.ShowHead=0;

    if CC.AutoWarShowHead==1 then
	    WAR.ShowHead=1;
	end

    local autotype=War_Think();         --˼�����ս��

    if autotype==0 then  --��Ϣ
        War_AutoEscape();  --���ܿ�
        War_RestMenu();
    elseif autotype==1 then
        War_AutoFight();      --�Զ�ս��
    elseif autotype==2 then    --��ҩ������
        War_AutoEscape();
        War_AutoEatDrug(2);
    elseif autotype==3 then    --��ҩ������
        War_AutoEscape();
         War_AutoEatDrug(3);
    elseif autotype==4 then    --��ҩ������
        War_AutoEscape();
        War_AutoEatDrug(4);
    elseif autotype==5 then    --�Լ�ҽ��
        War_AutoEscape();
        War_AutoDoctor();
    elseif autotype==6 then    --��ҩ�ⶾ
        War_AutoEscape();
        War_AutoEatDrug(6);
    end

    return 0;
end

--˼�����ս��
--���أ�0 ��Ϣ�� 1 ս����2 ʹ����Ʒ���������� 3 ʹ����Ʒ�������� 4 ��ҩ�������� 5 ҽ��
--     6 ʹ����Ʒ�ⶾ

function War_Think()           --˼�����ս��
    local pid=WAR.Person[WAR.CurID]["������"];
    local r=-1;         --���ǵĽ��

    if JY.Person[pid]["����"] <10 then         --��Ϣ
        r=War_ThinkDrug(4);
        if r>=0 then
            return r;
        end
        return 0;
    end

    if JY.Person[pid]["����"]<20 or JY.Person[pid]["���˳̶�"]>50 then
        r=War_ThinkDrug(2);       --������������
        if r>=0 then
            return r;
        end
    end

    local rate=-1;         --���������İٷֱ�
    if JY.Person[pid]["����"] <JY.Person[pid]["�������ֵ"] /5 then
        rate=90;
    elseif JY.Person[pid]["����"] <JY.Person[pid]["�������ֵ"] /4 then
        rate=70;
    elseif JY.Person[pid]["����"] <JY.Person[pid]["�������ֵ"] /3 then
        rate=50;
    elseif JY.Person[pid]["����"] <JY.Person[pid]["�������ֵ"] /2 then
        rate=25;
    end

    if Rnd(100)<rate then
        r=War_ThinkDrug(2);       --������������
        if r>=0 then
            return r;
        else             --û������������ҩ�������Ƿ��Լ�ҽ��
		    r=War_ThinkDoctor();
		    if r>=0 then
		       return r;
		    end
        end
    end

    rate=-1;         --���������İٷֱ�
    if JY.Person[pid]["����"] <JY.Person[pid]["�������ֵ"] /5 then
        rate=75;
    elseif JY.Person[pid]["����"] <JY.Person[pid]["�������ֵ"] /4 then
        rate=50;
    end

    if Rnd(100)<rate then
        r=War_ThinkDrug(3);       --������������
        if r>=0 then
            return r;
        end
    end


    rate=-1;         --�ⶾ�İٷֱ�
    if JY.Person[pid]["�ж��̶�"] > CC.PersonAttribMax["�ж��̶�"] *3/4 then
        rate=60;
    elseif JY.Person[pid]["�ж��̶�"] >CC.PersonAttribMax["�ж��̶�"] /2 then
        rate=30;
    end

    if Rnd(100)<rate then
        r=War_ThinkDrug(6);       --���ǽⶾ
        if r>=0 then
            return r;
        end
    end

    local minNeili=War_GetMinNeiLi(pid);     --�����书����С����

    if JY.Person[pid]["����"]>=minNeili then
        r=1;
    else
        r=0;
    end

    return r;
end

--�ܷ��ҩ���Ӳ���
--flag=2 ������3������4����  6 �ⶾ
function War_ThinkDrug(flag)             --�ܷ��ҩ���Ӳ���
    local pid=WAR.Person[WAR.CurID]["������"];
    local str;
    local r=-1;

    if flag==2 then
        str="������";
    elseif flag==3 then
        str="������";
    elseif flag==4 then
        str="������";
    elseif flag==6 then
        str="���ж��ⶾ";
    else
        return r;
    end

    local function Get_Add(thingid)    --����ֲ�������ȡ����Ʒthingid���ӵ�ֵ
		if flag==6 then
			return -JY.Thing[thingid][str];   --�ⶾΪ��ֵ
		else
			return JY.Thing[thingid][str];
		end
    end

    if WAR.Person[WAR.CurID]["�ҷ�"]==true then
        for i =1, CC.MyThingNum do
            local thingid=JY.Base["��Ʒ" ..i];
            if thingid>=0 then
                if JY.Thing[thingid]["����"]==3 and Get_Add(thingid)>0 then
                    r=flag;                     ---������������ҩ��������ʹ����Ʒ������
                    break;
                end
            end
        end
    else
        for i =1, 4 do
            local thingid=JY.Person[pid]["Я����Ʒ" ..i];
            if thingid>=0 then
                if JY.Thing[thingid]["����"]==3 and Get_Add(thingid)>0  then
                    r=flag;                     ---������������ҩ��������ʹ����Ʒ������
                    break;
                end
            end
        end
    end

    return r;

end


--�����Ƿ��Լ�ҽ��
function War_ThinkDoctor()          --�����Ƿ���Լ�ҽ��
    local pid=WAR.Person[WAR.CurID]["������"];

	if JY.Person[pid]["����"]<50 or JY.Person[pid]["ҽ������"]<20 then
	    return -1;
	end

	if JY.Person[pid]["���˳̶�"]>JY.Person[pid]["ҽ������"]+20 then
	    return -1;
	end

	local rate = -1;
	local v=JY.Person[pid]["�������ֵ"]-JY.Person[pid]["����"];
	if JY.Person[pid]["ҽ������"] < v/4 then
        rate=30;
	elseif JY.Person[pid]["ҽ������"] < v/3 then
	    rate=50;
	elseif JY.Person[pid]["ҽ������"] < v/2 then
	    rate=70;
	else
	    rate=90;
	end

	if Rnd(100) <rate then
	    return 5;
	end

	return -1;
end

---�Զ�ս��
function War_AutoFight()             ---ִ���Զ�ս��

	local wugongnum=War_AutoSelectWugong();    --ѡ���书

	if wugongnum <=0 then --û��ѡ���书����Ϣ
        War_AutoEscape();
        War_RestMenu();
		return
	end

	local r=War_AutoMove(wugongnum);         -- �����˷����ƶ�
	if r==1 then   --����ڹ�����Χ
		War_AutoExecuteFight(wugongnum);     --����
	else
   	    War_RestMenu();           --��Ϣ
	end
end


function War_AutoSelectWugong()           --�Զ�ѡ����ʵ��书
    local pid=WAR.Person[WAR.CurID]["������"];

    local probability={};       --ÿ���书ѡ��ĸ���

    local wugongnum=10;         --ȱʡ10���书
	for i =1, 10 do             --����ÿ�ֿ�ѡ���书���ܹ�����
        local wugongid=JY.Person[pid]["�书" .. i];
        if wugongid>0 then
		       --ѡ��ɱ�������书������������������������С��������Է���һ�����书��
            if JY.Wugong[wugongid]["�˺�����"]==0 then
				if JY.Wugong[wugongid]["������������"]<=JY.Person[pid]["����"] then
					local level=math.modf(JY.Person[pid]["�书�ȼ�" .. i]/100)+1;
					--�ܹ�������Ϊ����
					probability[i]=(JY.Person[pid]["������"]*3+JY.Wugong[wugongid]["������" .. level ])/2;
				else
					probability[i]=0;
				end
			else            --ɱ�������书
                probability[i]=10;  --��С�ĸ���ѡ��ɱ����
			end
		else
		    wugongnum=i-1;
			break;
        end
    end

    local maxoffense=0;       --������󹥻���
	for i =1, wugongnum do
        if  probability[i]>maxoffense then
            maxoffense=probability[i];
        end
    end

    local mynum=0;             --�����ҷ��͵��˸���
	local enemynum=0;
	for i=0, WAR.PersonNum-1 do
	    if WAR.Person[i]["����"]==false then
		    if WAR.Person[i]["�ҷ�"]==WAR.Person[WAR.CurID]["�ҷ�"] then
			    mynum=mynum+1;
			else
			    enemynum=enemynum+1;
			end
		end
	end

    local factor=0;       --��������Ӱ�����ӣ����˶��������ȹ��������书��ѡ���������
	if enemynum>mynum then
	    factor=2;
	else
	    factor=1;
	end

	for i =1, wugongnum do       --������������Ч��
        local wugongid=JY.Person[pid]["�书" .. i];
        if probability[i]>0 then
		    if probability[i]<maxoffense/2 then       --ȥ��������С���书
			    probability[i]=0
			end
			local extranum=0;           --�书������ϵĹ�����
			for j,v in ipairs(CC.ExtraOffense) do
				if v[1]==JY.Person[pid]["����"] and v[2]==wugongid then
					extranum=v[3];
					break;
				end
			end
    		local level=math.modf(JY.Person[pid]["�书�ȼ�" .. i]/100)+1;
			probability[i]=probability[i]+JY.Wugong[wugongid]["������Χ"]*factor*JY.Wugong[wugongid]["ɱ�˷�Χ" ..level]*20;
        end
    end

	local s={};           --���ո��������ۼ�
	local maxnum=0;
    for i=1,wugongnum do
        s[i]=maxnum;
		maxnum=maxnum+probability[i];
	end
	s[wugongnum+1]=maxnum;

	if maxnum==0 then    --û�п���ѡ����书
	    return -1;
	end

    local v=Rnd(maxnum);            --���������
	local selectid=0;
    for i=1,wugongnum do            --���ݲ������������Ѱ�������ĸ��书����
	    if v>=s[i] and v< s[i+1] then
		    selectid=i;
			break;
		end
	end

    return selectid;
end


function War_AutoSelectEnemy()             --ѡ��ս������
    local enemyid=War_AutoSelectEnemy_near()
    WAR.Person[WAR.CurID]["�Զ�ѡ�����"]=enemyid;
    return enemyid;
end


function War_AutoSelectEnemy_near()              --ѡ���������

    War_CalMoveStep(WAR.CurID,100,1);           --���ÿ��λ�õĲ���

    local maxDest=math.huge;
    local nearid=-1;
    for i=0,WAR.PersonNum-1 do           --������������ĵ���
        if WAR.Person[WAR.CurID]["�ҷ�"] ~=WAR.Person[i]["�ҷ�"] then
            if WAR.Person[i]["����"]==false then
			   local step=GetWarMap(WAR.Person[i]["����X"],WAR.Person[i]["����Y"],3);
                if step<maxDest then
                    nearid=i;
                    maxDest=step;
                end
            end
        end
    end
    return nearid;
end

--�Զ������˷����ƶ�
--�����书��ţ������书id
--���� 1=���Թ������ˣ� 0 ���ܹ���
function War_AutoMove(wugongnum)              --�Զ������˷����ƶ�
    local pid=WAR.Person[WAR.CurID]["������"];
    local wugongid=JY.Person[pid]["�书"  ..wugongnum];
    local level=math.modf(JY.Person[pid]["�书�ȼ�".. wugongnum]/100)+1;

    local wugongtype=JY.Wugong[wugongid]["������Χ"];
	local movescope=JY.Wugong[wugongid]["�ƶ���Χ" ..level];
	local fightscope=JY.Wugong[wugongid]["ɱ�˷�Χ" ..level];
    local scope=movescope+fightscope;


    local x,y;
	local move=128;
    local maxenemy=0;

	local movestep=War_CalMoveStep(WAR.CurID,WAR.Person[WAR.CurID]["�ƶ�����"],0);   --�����ƶ�����

	War_AutoCalMaxEnemyMap(wugongid,level);  --������书����������Թ��������˵ĸ���

	for i=0,WAR.Person[WAR.CurID]["�ƶ�����"] do
	    local step_num=movestep[i].num ;
		if step_num==0 then
		    break;
		end
		for j=1,step_num do
		    local xx=movestep[i].x[j];
			local yy=movestep[i].y[j]

			local num=0;
			if wugongtype==0 or wugongtype==2 or wugongtype==3 then
				num=GetWarMap(xx,yy,4)      --�������λ�ÿ��Թ������������˸���
			elseif wugongtype==1  then
				local v=GetWarMap(xx,yy,4)      --�������λ�ÿ��Թ������������˸���
				if v>0 then
					num=War_AutoCalMaxEnemy(xx,yy,wugongid,level);
				end
			end
			if num>maxenemy then
				maxenemy=num
				x=xx;
				y=yy;
				move=i;
			elseif num==maxenemy and num>0 then
			    if Rnd(3)==0 then
					maxenemy=num
					x=xx;
					y=yy;
					move=i;
				end
			end
		end
	end

    if maxenemy>0 then
	    War_CalMoveStep(WAR.CurID,WAR.Person[WAR.CurID]["�ƶ�����"],0);   --���¼����ƶ�����
        War_MovePerson(x,y);    --�ƶ�����Ӧ��λ��
		return 1;
	else   --�κ��ƶ���ֱ�ӹ����������ˣ�Ѱ��һ�������ƶ�������������λ�õ�·��
		x,y=War_GetCanFightEnemyXY(scope);       --������Թ��������˵����λ��

		local minDest=math.huge;
        if x==nil then   --�޷��ߵ����Թ������˵ĵط������ܵ��˱�Χס�����߱�����Χס��
             local enemyid=War_AutoSelectEnemy()   --ѡ���������

			 War_CalMoveStep(WAR.CurID,100,0);   --�����ƶ����� �������100��

			 for i=0,CC.WarWidth-1 do
                for j=0,CC.WarHeight-1 do
					local dest=GetWarMap(i,j,3);
                    if dest <128 then
                        local dx=math.abs(i-WAR.Person[enemyid]["����X"])
                        local dy=math.abs(j-WAR.Person[enemyid]["����Y"])
                        if minDest>(dx+dy) then        --��ʱx,y�Ǿ�����˵����·������Ȼ���ܱ�Χס
                            minDest=dx+dy;
                            x=i;
                            y=j;
                        elseif minDest==(dx+dy) then
                            if Rnd(2)==0 then
                                x=i;
                                y=j;
                            end
                        end
                    end
                end
            end
		else
            minDest=0;        --�����ߵ�
		end

		if minDest<math.huge then   --��·����
		    while true do    --��Ŀ��λ�÷����ҵ������ƶ���λ�ã���Ϊ�ƶ��Ĵ���
				local i=GetWarMap(x,y,3);
                if i<=WAR.Person[WAR.CurID]["�ƶ�����"] then
                    break;
                end

                if GetWarMap(x-1,y,3)==i-1 then
                    x=x-1;
                elseif GetWarMap(x+1,y,3)==i-1 then
                    x=x+1;
                elseif GetWarMap(x,y-1,3)==i-1 then
                    y=y-1;
                elseif GetWarMap(x,y+1,3)==i-1 then
                    y=y+1;
                end
            end
            War_MovePerson(x,y);    --�ƶ�����Ӧ��λ��
        end
    end

    return 0;
end

--�õ������ߵ����������˵����λ�á�
--scope���Թ����ķ�Χ
--���� x,y������޷��ߵ�����λ�ã����ؿ�


function War_GetCanFightEnemyXY(scope)             --�õ������ߵ����������˵����λ��

    local minStep=math.huge;
	local newx,newy;

	War_CalMoveStep(WAR.CurID,100,0);   --�����ƶ����� �������100��
	for x=0,CC.WarWidth-1 do
		for y=0,CC.WarHeight-1 do
			if GetWarMap(x,y,4)>0 then    --���λ�ÿ��Թ���������
				local step=GetWarMap(x,y,3);
				if step<128 then
					if minStep>step then
						minStep=step;
						newx=x;
						newy=y;
					elseif minStep==step then
						if Rnd(2)==0 then
							newx=x;
							newy=y;
						end
					end
				end
			end
		end
	end

	if minStep<math.huge then
	    return newx,newy;
    end
end


function War_AutoCalMaxEnemyMap(wugongid,level)       --�����ͼ��ÿ��λ�ÿ��Թ����ĵ�����Ŀ

    local wugongtype=JY.Wugong[wugongid]["������Χ"];
    local movescope=JY.Wugong[wugongid]["�ƶ���Χ" ..level];
	local fightscope=JY.Wugong[wugongid]["ɱ�˷�Χ" ..level];

	local x0=WAR.Person[WAR.CurID]["����X"];
	local y0=WAR.Person[WAR.CurID]["����Y"];

 	CleanWarMap(4,0);    --��level 4��ͼ��ʾ��Щλ�ÿ��Թ���������

----�㹥�����湥��, ÿ��������Թ����ĵ��˸�������Ȼֻ��Ϊ0��1��
---�����湥���͵㹥��һ�������ᵼ���湥�����ܲ��ܹ��������ĵ��ˣ����������ٶȿ�
	if wugongtype==0 or wugongtype==3 then
		for n=0,WAR.PersonNum-1 do
			if n~=WAR.CurID and WAR.Person[n]["����"]==false and
				WAR.Person[n]["�ҷ�"] ~=WAR.Person[WAR.CurID]["�ҷ�"] then   --����
				local xx=WAR.Person[n]["����X"];
				local yy=WAR.Person[n]["����Y"];
				local movestep=War_CalMoveStep(n,movescope,1);   --�����书�ƶ�����
				for i=1,movescope do
					local step_num=movestep[i].num ;
					if step_num==0 then
						break;
					end
					for j=1,step_num do
						SetWarMap(movestep[i].x[j],movestep[i].y[j],4,1);  --����书�ƶ��ĵط�����Ϊ�ɹ���������֮��
					end
				end
		end
		end
--�߹�����ʮ�� ��¼ÿ���ĵ���Թ��������˵ĸ��������߹��������鲢��׼ȷ����Ҫ��һ����ʵ��
	elseif wugongtype==1 or wugongtype==2  then
		for n=0,WAR.PersonNum-1 do
			if n~=WAR.CurID and WAR.Person[n]["����"]==false and
				WAR.Person[n]["�ҷ�"] ~=WAR.Person[WAR.CurID]["�ҷ�"] then   --����
				local xx=WAR.Person[n]["����X"];
				local yy=WAR.Person[n]["����Y"];
				for direct=0,3 do
					for i=1,movescope do
						local xnew=xx+CC.DirectX[direct+1]*i;
						local ynew=yy+CC.DirectY[direct+1]*i;
						if xnew>=0 and xnew<CC.WarWidth and ynew>=0 and ynew<CC.WarHeight then
							local v=GetWarMap(xnew,ynew,4);
							SetWarMap(xnew,ynew,4,v+1);
						end
					end
				end
			end
		end

	end

end


function War_AutoCalMaxEnemy(x,y,wugongid,level)       --�����(x,y)��ʼ��������ܹ����м�������

    local wugongtype=JY.Wugong[wugongid]["������Χ"];
    local movescope=JY.Wugong[wugongid]["�ƶ���Χ" ..level];
	local fightscope=JY.Wugong[wugongid]["ɱ�˷�Χ" ..level];

	local maxnum=0;
	local xmax,ymax;

	if wugongtype==0 or wugongtype==3 then

		local movestep=War_CalMoveStep(WAR.CurID,movescope,1);   --�����书�ƶ�����
		for i=1,movescope do
			local step_num=movestep[i].num ;
			if step_num==0 then
				break;
			end
			for j=1,step_num do
				local xx=movestep[i].x[j];
				local yy=movestep[i].y[j];
				local enemynum=0;

				for n=0,WAR.PersonNum-1 do   --�����书������Χ�ڵĵ��˸���
					 if n~=WAR.CurID and WAR.Person[n]["����"]==false and
					    WAR.Person[n]["�ҷ�"] ~=WAR.Person[WAR.CurID]["�ҷ�"] then
						 local x=math.abs(WAR.Person[n]["����X"]-xx);
						 local y=math.abs(WAR.Person[n]["����Y"]-yy);
						 if x<=fightscope and y <=fightscope then
							  enemynum=enemynum+1;
						 end
					 end
				end

				if enemynum>maxnum then        --��¼�����˺�λ��
					maxnum=enemynum;
					xmax=xx;
					ymax=yy;
				end
			end
		end

	elseif wugongtype==1 then    --�߹���
		for direct=0,3 do           -- ��ÿ������ѭ�����ҳ���������
			local enemynum=0;
			for i=1,movescope do
				local xnew=x+CC.DirectX[direct+1]*i;
				local ynew=y+CC.DirectY[direct+1]*i;

				if xnew>=0 and xnew<CC.WarWidth and ynew>=0 and ynew<CC.WarHeight then
					local id=GetWarMap(xnew,ynew,2);
					if id>=0 then
						if WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[id]["�ҷ�"] then
							enemynum=enemynum+1;                  --�书������Χ�ڵĵ��˸���
						end
					end
				end
			end
			if enemynum>maxnum then        --��¼�����˺�λ��
				maxnum=enemynum;
				xmax=x+CC.DirectX[direct+1];       --�߹�����¼һ�������������
				ymax=y+CC.DirectY[direct+1];
			end
		end

	elseif wugongtype==2 then --ʮ�ֹ���
		local enemynum=0;
		for direct=0,3 do           -- ��ÿ������ѭ��
			for i=1,movescope do
				local xnew=x+CC.DirectX[direct+1]*i;
				local ynew=y+CC.DirectY[direct+1]*i;
				if xnew>=0 and xnew<CC.WarWidth and ynew>=0 and ynew<CC.WarHeight then
					local id=GetWarMap(xnew,ynew,2);
					if id>=0 then
						if WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[id]["�ҷ�"] then
							enemynum=enemynum+1;                  --�书������Χ�ڵĵ��˸���
						end
					end
				end
			end
		end
		if enemynum>0 then
			maxnum=enemynum;
			xmax=x;
			ymax=y;
		end
	end
	return maxnum,xmax,ymax;
end

--�Զ�ִ��ս������ʱ��λ��һ�����Դ򵽵���
function War_AutoExecuteFight(wugongnum)            --�Զ�ִ��ս������ʾ��������
    local pid=WAR.Person[WAR.CurID]["������"];
    local x0=WAR.Person[WAR.CurID]["����X"];
    local y0=WAR.Person[WAR.CurID]["����Y"];
    local wugongid=JY.Person[pid]["�书"  ..wugongnum];
    local level=math.modf(JY.Person[pid]["�书�ȼ�".. wugongnum]/100)+1;

    local maxnum,x,y=War_AutoCalMaxEnemy(x0,y0,wugongid,level);

    if x ~= nil then
        War_Fight_Sub(WAR.CurID,wugongnum,x,y);
	end

end

--����
function War_AutoEscape()                --����
    local pid=WAR.Person[WAR.CurID]["������"];
    if JY.Person[pid]["����"]<=5  then
	    return
	end

    local maxDest=0;
    local x,y;

    War_CalMoveStep(WAR.CurID,WAR.Person[WAR.CurID]["�ƶ�����"],0);   --�����ƶ�����

    for i=0,CC.WarWidth-1 do
        for j=0,CC.WarHeight-1 do
			if GetWarMap(i,j,3)<128 then
                local minDest=math.huge;
                for k=0,WAR.PersonNum-1 do
                    if WAR.Person[WAR.CurID]["�ҷ�"]~=WAR.Person[k]["�ҷ�"] and WAR.Person[k]["����"]==false then
                        local dx=math.abs(i-WAR.Person[k]["����X"])
                        local dy=math.abs(j-WAR.Person[k]["����Y"])
                        if minDest>(dx+dy) then        --���㵱ǰ������������λ��
                            minDest=dx+dy;
                        end
                    end
                end

                if minDest>maxDest then           --��һ����Զ��λ��
                    maxDest=minDest;
                    x=i;
                    y=j;
                end
            end
        end
    end

    if maxDest>0 then
        War_MovePerson(x,y);    --�ƶ�����Ӧ��λ��
    end

end


---��ҩ
----flag=2 ������3������4����  6 �ⶾ
function War_AutoEatDrug(flag)          ---��ҩ�Ӳ���
    local pid=WAR.Person[WAR.CurID]["������"];
    local life=JY.Person[pid]["����"];
    local maxlife=JY.Person[pid]["�������ֵ"];
    local selectid;
    local minvalue=math.huge;

    local shouldadd;
    local maxattrib;
    local str;
    if flag==2 then
        maxattrib=JY.Person[pid]["�������ֵ"];
        shouldadd=maxattrib-JY.Person[pid]["����"];
        str="������";
    elseif flag==3 then
        maxattrib=JY.Person[pid]["�������ֵ"];
        shouldadd=maxattrib-JY.Person[pid]["����"];
        str="������";
    elseif flag==4 then
        maxattrib=CC.PersonAttribMax["����"];
        shouldadd=maxattrib-JY.Person[pid]["����"];
        str="������";
    elseif flag==6 then
        maxattrib=CC.PersonAttribMax["�ж��̶�"];
        shouldadd=JY.Person[pid]["�ж��̶�"];
        str="���ж��ⶾ";
    else
        return ;
    end

    local function Get_Add(thingid)     --������Ʒ���ӵ�ֵ
	    if flag==6 then
		    return -JY.Thing[thingid][str]/2;   --�ⶾΪ��ֵ
		else
            return JY.Thing[thingid][str];
		end
	end

    if WAR.Person[WAR.CurID]["�ҷ�"]==true then
        local extra=0;
        for i =1, CC.MyThingNum do
            local thingid=JY.Base["��Ʒ" ..i];
            if thingid>=0 then
                local add=Get_Add(thingid);
                if JY.Thing[thingid]["����"]==3 and add>0 then
                    local v=shouldadd-add;
                    if v<0 then               --���Լ���, �����������Һ���ҩƷ
                        extra=1;
                        break;
                    else
                        if v<minvalue then        --Ѱ�Ҽ���������������
                            minvalue=v;
                            selectid=thingid;
                        end
                    end
                end
            end
        end
        if extra==1 then
            minvalue=math.huge;
            for i =1, CC.MyThingNum do
                local thingid=JY.Base["��Ʒ" ..i];
                if thingid>=0 then
                    local add=Get_Add(thingid);
                    if JY.Thing[thingid]["����"]==3 and add>0 then
                        local v=add-shouldadd;
                        if v>=0 then               --���Լ�������
                            if v<minvalue then
                                minvalue=v;
                                selectid=thingid;
                            end
                        end
                    end
                end
            end
        end
        if UseThingEffect(selectid,pid)==1 then       --ʹ����Ч��
            instruct_32(selectid,-1);            --��Ʒ��������
        end
    else
        local extra=0;
        for i =1, 4 do
            local thingid=JY.Person[pid]["Я����Ʒ" ..i];
            if thingid>=0 then
                local add=Get_Add(thingid);
                if JY.Thing[thingid]["����"]==3 and add>0 then
                    local v=shouldadd-add;
                    if v<0 then               --���Լ�������, �����������Һ���ҩƷ
                        extra=1;
                        break;
                    else
                        if v<minvalue then        --Ѱ�Ҽ���������������
                            minvalue=v;
                            selectid=thingid;
                        end
                    end
                end
            end
        end
        if extra==1 then
            minvalue=math.huge;
            for i =1, 4 do
                local thingid=JY.Person[pid]["Я����Ʒ" ..i];
                if thingid>=0 then
                    local add=Get_Add(thingid);
                    if JY.Thing[thingid]["����"]==3 and add>0 then
                        local v=add-shouldadd;
                        if v>=0 then               --���Լ�������
                            if v<minvalue then
                                minvalue=v;
                                selectid=thingid;
                            end
                        end
                    end
                end
            end
        end

        if UseThingEffect(selectid,pid)==1 then       --ʹ����Ч��
            instruct_41(pid,selectid,-1);            --��Ʒ��������
        end
    end

    lib.Delay(500);
end


--�Զ�ҽ��
function War_AutoDoctor()            --�Զ�ҽ��
    local x1=WAR.Person[WAR.CurID]["����X"];
    local y1=WAR.Person[WAR.CurID]["����Y"];

    War_ExecuteMenu_Sub(x1,y1,3,-1);
end


