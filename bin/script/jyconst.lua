
--����ȫ�ֱ���CC��������Ϸ��ʹ�õĳ���
function SetGlobalConst()
    -- SDL ���붨�壬����������Ȼʹ��directx������
    VK_ESCAPE=27
    VK_Y=121
	VK_N=110
	VK_SPACE=32
	VK_RETURN=13

	SDLK_UP=273
	SDLK_DOWN=274
	SDLK_LEFT=276
	SDLK_RIGHT=275

	if CONFIG.Rotate==0 then
	    VK_UP=SDLK_UP;
	    VK_DOWN=SDLK_DOWN;
	    VK_LEFT=SDLK_LEFT;
	    VK_RIGHT=SDLK_RIGHT;
	else           --��ת90��
	    VK_UP=SDLK_RIGHT;
	    VK_DOWN=SDLK_LEFT;
	    VK_LEFT=SDLK_UP;
	    VK_RIGHT=SDLK_DOWN;
	end


   -- ��Ϸ����ɫ����
    C_STARTMENU=RGB(132, 0, 4)            -- ��ʼ�˵���ɫ
    C_RED=RGB(216, 20, 24)                -- ��ʼ�˵�ѡ������ɫ

    C_WHITE=RGB(236, 236, 236);           --��Ϸ�ڳ��õļ�����ɫֵ
    C_ORANGE=RGB(252, 148, 16);
    C_GOLD=RGB(236, 200, 40);
    C_BLACK=RGB(0,0,0);


   -- ��Ϸ״̬����
    GAME_START =0       --��ʼ����
    GAME_FIRSTMMAP = 1  --��һ����ʾ����ͼ
    GAME_MMAP =2;       --����ͼ
    GAME_FIRSTSMAP = 3  --��һ����ʾ����ͼ
    GAME_SMAP =4;       --������ͼ
    GAME_WMAP =5;       --ս����ͼ
	GAME_DEAD =6;       --��������
    GAME_END  =7;       --����

   --��Ϸ����ȫ�ֱ���
   CC={};      --������Ϸ��ʹ�õĳ�������Щ�������޸���Ϸʱ�޸�֮

   CC.SrcCharSet=0;         --Դ������ַ��� 0 gb  1 big5������ת��R���� ���Դ�뱻ת��Ϊbig5����Ӧ��Ϊ1
   CC.OSCharSet=CONFIG.OSCharSet;         --OS �ַ�����0 GB, 1 Big5
   CC.FontName=CONFIG.FontName;    --��ʾ����

   CC.ScreenW=CONFIG.Width;          --��ʾ���ڿ��
   CC.ScreenH=CONFIG.Height;

   --�����¼�ļ�����S��D�����ǹ̶���С����˲��ٶ���idx�ˡ�
   CC.R_IDXFilename={[0]=CONFIG.DataPath .. "ranger.idx",
                     CONFIG.DataPath .. "r1.idx",
					 CONFIG.DataPath .. "r2.idx",
					 CONFIG.DataPath .. "r3.idx",};
   CC.R_GRPFilename={[0]=CONFIG.DataPath .. "ranger.grp",
                     CONFIG.DataPath .. "r1.grp",
					 CONFIG.DataPath .. "r2.grp",
					 CONFIG.DataPath .. "r3.grp",};
   CC.S_Filename={[0]=CONFIG.DataPath .. "allsin.grp",
                  CONFIG.DataPath .. "s1.grp",
				  CONFIG.DataPath .. "s2.grp",
				  CONFIG.DataPath .. "s3.grp",};

   CC.TempS_Filename=CONFIG.DataPath .. "allsinbk.grp";

   CC.D_Filename={[0]=CONFIG.DataPath .. "alldef.grp",
                   CONFIG.DataPath .. "d1.grp",
				   CONFIG.DataPath .. "d2.grp",
				   CONFIG.DataPath .. "d3.grp",};

   CC.PaletteFile=CONFIG.DataPath .. "mmap.col";

   CC.FirstFile=CONFIG.PicturePath .. "title.png";
   CC.DeadFile=CONFIG.PicturePath .. "dead.png";

   CC.MMapFile={CONFIG.DataPath .. "earth.002",
                CONFIG.DataPath .. "surface.002",
				CONFIG.DataPath .. "building.002",
		        CONFIG.DataPath .. "buildx.002",
				CONFIG.DataPath .. "buildy.002"};

   --������ͼ�ļ�����
   CC.MMAPPicFile={CONFIG.DataPath .. "mmap.idx",CONFIG.DataPath .. "mmap.grp"};
   CC.SMAPPicFile={CONFIG.DataPath .. "smap.idx",CONFIG.DataPath .. "smap.grp"};
   CC.WMAPPicFile={CONFIG.DataPath .. "wmap.idx",CONFIG.DataPath .. "wmap.grp"};
   CC.EffectFile={CONFIG.DataPath .. "eft.idx",CONFIG.DataPath .. "eft.grp"};
   CC.FightPicFile={CONFIG.DataPath .. "fight%03d.idx",CONFIG.DataPath .. "fight%03d.grp"};  --�˴�Ϊ�ַ�����ʽ��������C��printf�ĸ�ʽ��

   CC.HeadPicFile={CONFIG.DataPath .. "hdgrp.idx",CONFIG.DataPath .. "hdgrp.grp"};
   CC.ThingPicFile={CONFIG.DataPath .. "thing.idx",CONFIG.DataPath .. "thing.grp"};


   CC.MIDIFile=CONFIG.SoundPath .. "game%02d.mid";
   CC.ATKFile=CONFIG.SoundPath .. "atk%02d.wav";
   CC.EFile=CONFIG.SoundPath .. "e%02d.wav";

   CC.WarFile=CONFIG.DataPath .. "war.sta";
   CC.WarMapFile={CONFIG.DataPath .. "warfld.idx",
                  CONFIG.DataPath .. "warfld.grp"};

   CC.TalkIdxFile=CONFIG.ScriptPath .. "oldtalk.idx";
   CC.TalkGrpFile=CONFIG.ScriptPath .. "oldtalk.grp";

   --�����¼�ļ�R���ṹ��  lua��֧�ֽṹ���޷�ֱ�ӴӶ������ļ��ж�ȡ�������Ҫ��Щ���壬��table�в�ͬ������������ṹ��
   CC.TeamNum=6;          --��������
   CC.MyThingNum=200      --������Ʒ����

   CC.Base_S={};         --����������ݵĽṹ���Ա��Ժ��ȡ
   CC.Base_S["�˴�"]={0,0,2}   -- ��ʼλ��(��0��ʼ)����������(0�з��� 1�޷��ţ�2�ַ���)������
   CC.Base_S["����"]={2,0,2};
   CC.Base_S["��X"]={4,0,2};
   CC.Base_S["��Y"]={6,0,2};
   CC.Base_S["��X1"]={8,0,2};
   CC.Base_S["��Y1"]={10,0,2};
   CC.Base_S["�˷���"]={12,0,2};
   CC.Base_S["��X"]={14,0,2};
   CC.Base_S["��Y"]={16,0,2};
   CC.Base_S["��X1"]={18,0,2};
   CC.Base_S["��Y1"]={20,0,2};
   CC.Base_S["������"]={22,0,2};

   for i=1,CC.TeamNum do
        CC.Base_S["����" .. i]={24+2*(i-1),0,2};
   end

   for i=1,CC.MyThingNum do
        CC.Base_S["��Ʒ" .. i]={36+4*(i-1),0,2};
        CC.Base_S["��Ʒ����" .. i]={36+4*(i-1)+2,0,2};
   end

    CC.PersonSize=182;   --ÿ����������ռ���ֽ�
    CC.Person_S={};      --�����������ݵĽṹ���Ա��Ժ��ȡ
    CC.Person_S["����"]={0,0,2}
    CC.Person_S["ͷ�����"]={2,0,2}
    CC.Person_S["��������"]={4,0,2}
    CC.Person_S["����"]={6,0,2}
    CC.Person_S["����"]={8,2,10}
    CC.Person_S["���"]={18,2,10}
    CC.Person_S["�Ա�"]={28,0,2}
    CC.Person_S["�ȼ�"]={30,0,2}
    CC.Person_S["����"]={32,1,2}
    CC.Person_S["����"]={34,0,2}
    CC.Person_S["�������ֵ"]={36,0,2}
    CC.Person_S["���˳̶�"]={38,0,2}
    CC.Person_S["�ж��̶�"]={40,0,2}
    CC.Person_S["����"]={42,0,2}
    CC.Person_S["��Ʒ��������"]={44,0,2}
    CC.Person_S["����"]={46,0,2}
    CC.Person_S["����"]={48,0,2}

     for i=1,5 do
        CC.Person_S["���ж���֡��" .. i]={50+2*(i-1),0,2};
        CC.Person_S["���ж����ӳ�" .. i]={60+2*(i-1),0,2};
        CC.Person_S["�书��Ч�ӳ�" .. i]={70+2*(i-1),0,2};
     end

    CC.Person_S["��������"]={80,0,2}
    CC.Person_S["����"]={82,0,2}
    CC.Person_S["�������ֵ"]={84,0,2}
    CC.Person_S["������"]={86,0,2}
    CC.Person_S["�Ṧ"]={88,0,2}
    CC.Person_S["������"]={90,0,2}
    CC.Person_S["ҽ������"]={92,0,2}
    CC.Person_S["�ö�����"]={94,0,2}
    CC.Person_S["�ⶾ����"]={96,0,2}
    CC.Person_S["��������"]={98,0,2}

    CC.Person_S["ȭ�ƹ���"]={100,0,2}
    CC.Person_S["��������"]={102,0,2}
    CC.Person_S["ˣ������"]={104,0,2}
    CC.Person_S["�������"]={106,0,2}
    CC.Person_S["��������"]={108,0,2}


    CC.Person_S["��ѧ��ʶ"]={110,0,2}
    CC.Person_S["Ʒ��"]={112,0,2}
    CC.Person_S["��������"]={114,0,2}
    CC.Person_S["���һ���"]={116,0,2}
    CC.Person_S["����"]={118,0,2}

    CC.Person_S["����"]={120,0,2}
    CC.Person_S["������Ʒ"]={122,0,2}
    CC.Person_S["��������"]={124,0,2}

     for i=1,10 do
        CC.Person_S["�书" .. i]={126+2*(i-1),0,2};
        CC.Person_S["�书�ȼ�" .. i]={146+2*(i-1),0,2};
     end

     for i=1,4 do
        CC.Person_S["Я����Ʒ" .. i]={166+2*(i-1),0,2};
        CC.Person_S["Я����Ʒ����" .. i]={174+2*(i-1),0,2};
     end

    CC.ThingSize=190;   --ÿ����������ռ���ֽ�
    CC.Thing_S={};
    CC.Thing_S["����"]={0,0,2}
    CC.Thing_S["����"]={2,2,20}
    CC.Thing_S["����2"]={22,2,20}
    CC.Thing_S["��Ʒ˵��"]={42,2,30}
    CC.Thing_S["�����书"]={72,0,2}
    CC.Thing_S["�����������"]={74,0,2}
    CC.Thing_S["ʹ����"]={76,0,2}
    CC.Thing_S["װ������"]={78,0,2}
    CC.Thing_S["��ʾ��Ʒ˵��"]={80,0,2}
    CC.Thing_S["����"]={82,0,2}
    CC.Thing_S["δ֪5"]={84,0,2}
    CC.Thing_S["δ֪6"]={86,0,2}
    CC.Thing_S["δ֪7"]={88,0,2}
    CC.Thing_S["������"]={90,0,2}
    CC.Thing_S["���������ֵ"]={92,0,2}
    CC.Thing_S["���ж��ⶾ"]={94,0,2}
    CC.Thing_S["������"]={96,0,2}
    CC.Thing_S["�ı���������"]={98,0,2}
    CC.Thing_S["������"]={100,0,2}

    CC.Thing_S["���������ֵ"]={102,0,2}
    CC.Thing_S["�ӹ�����"]={104,0,2}
    CC.Thing_S["���Ṧ"]={106,0,2}
    CC.Thing_S["�ӷ�����"]={108,0,2}
    CC.Thing_S["��ҽ������"]={110,0,2}

    CC.Thing_S["���ö�����"]={112,0,2}
    CC.Thing_S["�ӽⶾ����"]={114,0,2}
    CC.Thing_S["�ӿ�������"]={116,0,2}
    CC.Thing_S["��ȭ�ƹ���"]={118,0,2}
    CC.Thing_S["����������"]={120,0,2}

    CC.Thing_S["��ˣ������"]={122,0,2}
    CC.Thing_S["���������"]={124,0,2}
    CC.Thing_S["�Ӱ�������"]={126,0,2}
    CC.Thing_S["����ѧ��ʶ"]={128,0,2}
    CC.Thing_S["��Ʒ��"]={130,0,2}

    CC.Thing_S["�ӹ�������"]={132,0,2}
    CC.Thing_S["�ӹ�������"]={134,0,2}
    CC.Thing_S["����������"]={136,0,2}
    CC.Thing_S["����������"]={138,0,2}
    CC.Thing_S["������"]={140,0,2}

    CC.Thing_S["�蹥����"]={142,0,2}
    CC.Thing_S["���Ṧ"]={144,0,2}
    CC.Thing_S["���ö�����"]={146,0,2}
    CC.Thing_S["��ҽ������"]={148,0,2}
    CC.Thing_S["��ⶾ����"]={150,0,2}

    CC.Thing_S["��ȭ�ƹ���"]={152,0,2}
    CC.Thing_S["����������"]={154,0,2}
    CC.Thing_S["��ˣ������"]={156,0,2}
    CC.Thing_S["���������"]={158,0,2}
    CC.Thing_S["�谵������"]={160,0,2}

    CC.Thing_S["������"]={162,0,2}
    CC.Thing_S["�辭��"]={164,0,2}
    CC.Thing_S["������Ʒ�辭��"]={166,0,2}
    CC.Thing_S["�����"]={168,0,2}

      for i=1,5 do
        CC.Thing_S["������Ʒ" .. i]={170+2*(i-1),0,2};
        CC.Thing_S["��Ҫ��Ʒ����" .. i]={180+2*(i-1),0,2};
     end

    CC.SceneSize=52;   --ÿ����������ռ���ֽ�
    CC.Scene_S={};
    CC.Scene_S["����"]={0,0,2}
    CC.Scene_S["����"]={2,2,10}
    CC.Scene_S["��������"]={12,0,2}
    CC.Scene_S["��������"]={14,0,2}
    CC.Scene_S["��ת����"]={16,0,2}
    CC.Scene_S["��������"]={18,0,2}
    CC.Scene_S["�⾰���X1"]={20,0,2}
    CC.Scene_S["�⾰���Y1"]={22,0,2}
    CC.Scene_S["�⾰���X2"]={24,0,2}
    CC.Scene_S["�⾰���Y2"]={26,0,2}
    CC.Scene_S["���X"]={28,0,2}
    CC.Scene_S["���Y"]={30,0,2}
    CC.Scene_S["����X1"]={32,0,2}
    CC.Scene_S["����X2"]={34,0,2}
    CC.Scene_S["����X3"]={36,0,2}
    CC.Scene_S["����Y1"]={38,0,2}
    CC.Scene_S["����Y2"]={40,0,2}
    CC.Scene_S["����Y3"]={42,0,2}
    CC.Scene_S["��ת��X1"]={44,0,2}
    CC.Scene_S["��ת��Y1"]={46,0,2}
    CC.Scene_S["��ת��X2"]={48,0,2}
    CC.Scene_S["��ת��Y2"]={50,0,2}

    CC.WugongSize=136;   --ÿ���书����ռ���ֽ�
    CC.Wugong_S={};
    CC.Wugong_S["����"]={0,0,2}
    CC.Wugong_S["����"]={2,2,10}
    CC.Wugong_S["δ֪1"]={12,0,2}
    CC.Wugong_S["δ֪2"]={14,0,2}
    CC.Wugong_S["δ֪3"]={16,0,2}
    CC.Wugong_S["δ֪4"]={18,0,2}
    CC.Wugong_S["δ֪5"]={20,0,2}
    CC.Wugong_S["������Ч"]={22,0,2}
    CC.Wugong_S["�书����"]={24,0,2}
    CC.Wugong_S["�书����&��Ч"]={26,0,2}
    CC.Wugong_S["�˺�����"]={28,0,2}
    CC.Wugong_S["������Χ"]={30,0,2}
    CC.Wugong_S["������������"]={32,0,2}
    CC.Wugong_S["�����ж�����"]={34,0,2}

     for i=1,10 do
        CC.Wugong_S["������" .. i]={36+2*(i-1),0,2};
        CC.Wugong_S["�ƶ���Χ" .. i]={56+2*(i-1),0,2};
        CC.Wugong_S["ɱ�˷�Χ" .. i]={76+2*(i-1),0,2};
        CC.Wugong_S["������" .. i]={96+2*(i-1),0,2};
        CC.Wugong_S["ɱ����" .. i]={116+2*(i-1),0,2};
     end

   CC.ShopSize=30;   --ÿ��С���̵�����ռ���ֽ�
   CC.Shop_S={};
   for i=1,5 do
      CC.Shop_S["��Ʒ" .. i]={0+2*(i-1),0,2};
      CC.Shop_S["��Ʒ����" .. i]={10+2*(i-1),0,2};
      CC.Shop_S["��Ʒ�۸�" .. i]={20+2*(i-1),0,2};
   end

   CC.ShopScene={};       --С���̵곡�����ݣ�sceneid ����id��d_shop С��λ��D*, d_leave С���뿪D*��һ���ڳ������ڣ�·������
   CC.ShopScene[0]={sceneid=1,d_shop=16,d_leave={17,18}, };
   CC.ShopScene[1]={sceneid=3,d_shop=14,d_leave={15,16}, };
   CC.ShopScene[2]={sceneid=40,d_shop=20,d_leave={21,22}, };
   CC.ShopScene[3]={sceneid=60,d_shop=16,d_leave={17,18}, };
   CC.ShopScene[4]={sceneid=61,d_shop=9,d_leave={10,11,12}, };

  --��������
   CC.MWidth=480;       --����ͼ��
   CC.MHeight=480;      --����ͼ��

   CC.SWidth=64;     --�ӳ�����ͼ��С
   CC.SHeight=64;

   CC.DNum=200;       --D*ÿ���������¼���

   CC.XScale=CONFIG.XScale;    --��ͼһ��Ŀ��
   CC.YScale=CONFIG.YScale;

   CC.Frame=50;     --ÿ֡������
   CC.SceneMoveFrame=CC.Frame*2;           --�����ƶ�֡�٣����ڳ����ƶ��¼�
   CC.PersonMoveFrame=CC.Frame*2;          --�����ƶ��ٶȣ����������ƶ��¼�
   CC.AnimationFrame=CC.Frame*3;           --������ʾ֡�٣�������ʾ�����¼�

   CC.WarAutoDelay=300;                   --�Զ�ս��ʱ��ʾͷ�����ʱ

   CC.DirectX={0,1,-1,0};  --��ͬ����x��y�ļӼ�ֵ��������·�ı�����ֵ
   CC.DirectY={-1,0,0,1};

   CC.MyStartPic=2501;      --������·��ʼ��ͼ
   CC.BoatStartPic=3715;    --����ʼ��ͼ

   CC.Level=30;                  ---����ȼ���ÿ�ȼ�����
   CC.Exp={    50,    150,     300 ,500   , 750 ,
               1050,  1400,   1800 ,2250  , 2750 ,
               3850,  5050,   6350 ,7750  , 9250 ,
               10850, 12550, 14350 ,16750 , 18250 ,
               21400, 24700, 28150 ,31750 , 35500 ,
	           39400, 43450, 47650 ,52000 , 60000  };

    CC.MMapBoat={};    --����ͼ�����Խ������ͼ
	local tmpBoat={ {0x166,0x16a},{0x176,0x17c},{0x1ca,0x1d0},{0x1fa,0x262},{0x3f8,0x3fe},};
    for i,v in ipairs(tmpBoat) do      --����Щ���ݱ任�����飬������ֵ���ǿ��Խ���
        for j=v[1],v[2],2 do
            CC.MMapBoat[j]=1;
        end
    end

    CC.SceneWater={};    --�����˲��ܽ������ͼ
    local tmpWater={ {0x166,0x16a},{0x176,0x17c},{0x1ca,0x1d0},{0x1fa,0x262},{0x332,0x338},
                     {0x346,0x346},{0x3a6,0x3a8},{0x3f8,0x3fe},{0x52c,0x544},};
    for i,v in ipairs(tmpWater) do      --����Щ���ݱ任�����飬���п�����ǿ��Խ������ͼ
        for j=v[1],v[2],2 do
            CC.SceneWater[j]=1;
        end
    end

    CC.WarWater={};    --ս����ͼ�˲��ܽ������ͼ
    local tmpWater={ {0x166,0x16a},{0x176,0x17c},{0x1ca,0x1d0},{0x1fa,0x262},{0x332,0x338},
                     {0x346,0x346},{0x3a6,0x3a8},{0x3f8,0x3fe},{0x52c,0x544},};
    for i,v in ipairs(tmpWater) do      --����Щ���ݱ任�����飬���п�����ǿ��Խ������ͼ
        for j=v[1],v[2],2 do
            CC.WarWater[j]=1;
        end
    end


    --�����Ա�б�: {��Աid����ӵ��ú���}      ----������µ������Ա���룬ֱ������������
    CC.PersonExit={{1,950},{2,952},{9,954},{16,956},{17,958},
                   {25,960},{28,962},{29,964},{35,966},{36,968},
                   {37,970},{38,972},{44,974},{45,976},{47,978},
                   {48,980},{49,982},{51,984},{53,986},{54,988},
                   {58,990},{59,992},{61,994},{63,996},{76,998},  }

    --���пɼ�����Ա�����Ҫ�����D*�¼����������Щ�˾��Ҳ����ˡ��õ�������ָ��ʹ��
    CC.AllPersonExit={ {0,0},{49,2},{4,1},{44,0},{44,1},{37,5},{30,0},{59,0},{40,3},{56,1},{1,7},{1,8},{1,10},
                       {40,7},{40,8},{77,0},{54,0},{62,3},{62,4},{60,2},{60,15},{52,1},{61,0},{61,8},{78,0},
                       {18,0},{18,1},{69,0},{69,1},{45,0},{52,2},{42,6},{42,7},{8,8},{7,6},{80,1}, };

    CC.BookNum=14;               --�������
    CC.BookStart=144;            --14������ʼ��Ʒid

    CC.MoneyID=174;              --��Ǯ��Ʒid

    CC.Shemale={ [78]=1,[93]=1}   --��Ҫ�Թ������id

   CC.Effect={[0]=9,14,17,9,13,                    --eft.idx/grp��ͼ�����书Ч����ͼ����
                 17,17,17,18,19,
                 19,15,13,10,10,
                 15,21,16,9,11,
                 8,9,8,8,7,
                 8,8,9,12,19,
                 11,14,12,17,8,
                 11,9,13,10,19,
                 14,17,19,14,21,
                 16,13,18,14,17,
                 17,16,7,   };

    CC.ExtraOffense={{106,57,100},             --�书����������ӹ������� ����Ϊ��������Ʒid���书id������������
                   {107,49,50},
                   {108,49,50},
                   {110,54,80},
                   {115,63,50},
                   {116,67,70},
                   {119,68,100},}

    CC.NewPersonName="��С��";                --����Ϸ������
    CC.NewGameSceneID=70;                      --����ID
    CC.NewGameSceneX=19;                       --��������
    CC.NewGameSceneY=20;
    CC.NewGameEvent=691;                       --����Ϸ����ִ���¼������û�У�������Ϸ���������û���¼���
    CC.NewPersonPic=3445;                      --��ʼ����pic

   CC.PersonAttribMax={};             --�����������ֵ
   CC.PersonAttribMax["����"]=60000;
   CC.PersonAttribMax["��Ʒ��������"]=60000;
   CC.PersonAttribMax["��������"]=60000;
   CC.PersonAttribMax["�������ֵ"]=999;
   CC.PersonAttribMax["���˳̶�"]=100;
   CC.PersonAttribMax["�ж��̶�"]=100;
   CC.PersonAttribMax["�������ֵ"]=999;
   CC.PersonAttribMax["����"]=100;
   CC.PersonAttribMax["������"]=100;
   CC.PersonAttribMax["������"]=100;
   CC.PersonAttribMax["�Ṧ"]=100;
   CC.PersonAttribMax["ҽ������"]=100;
   CC.PersonAttribMax["�ö�����"]=100;
   CC.PersonAttribMax["�ⶾ����"]=100;
   CC.PersonAttribMax["��������"]=100;
   CC.PersonAttribMax["ȭ�ƹ���"]=100;
   CC.PersonAttribMax["��������"]=100;
   CC.PersonAttribMax["ˣ������"]=100;
   CC.PersonAttribMax["�������"]=100;
   CC.PersonAttribMax["��������"]=100;
   CC.PersonAttribMax["��ѧ��ʶ"]=100;
   CC.PersonAttribMax["Ʒ��"]=100;
   CC.PersonAttribMax["����"]=100;
   CC.PersonAttribMax["��������"]=100;

    CC.WarDataSize=186;         --ս�����ݴ�С  war.sta���ݽṹ
    CC.WarData_S={};        --ս�����ݽṹ
    CC.WarData_S["����"]={0,0,2};
    CC.WarData_S["����"]={2,2,10};
    CC.WarData_S["��ͼ"]={12,0,2};
    CC.WarData_S["����"]={14,0,2};
    CC.WarData_S["����"]={16,0,2};
    for i=1,6 do
        CC.WarData_S["�ֶ�ѡ���ս��"  .. i]={18+(i-1)*2,0,2};
        CC.WarData_S["�Զ�ѡ���ս��"  .. i]={30+(i-1)*2,0,2};
        CC.WarData_S["�ҷ�X"  .. i]={42+(i-1)*2,0,2};
        CC.WarData_S["�ҷ�Y"  .. i]={54+(i-1)*2,0,2};
    end
    for i=1,20 do
        CC.WarData_S["����"  .. i]={66+(i-1)*2,0,2};
        CC.WarData_S["�з�X"  .. i]={106+(i-1)*2,0,2};
        CC.WarData_S["�з�Y"  .. i]={146+(i-1)*2,0,2};
    end

    CC.WarWidth=64;        --ս����ͼ��С
    CC.WarHeight=64;

	--��ʾ����ͼ�ͳ�����ͼ����
	--�����ʾ���꣬�������cpuռ�á������ٶ����Ļ����ܻῨ������ڵ���ʱ���á�
	--ע��: ���������CONFIG.FastShowScreen=1���򳡾��ӽǷ�Χ��������ʾ�����겻��ȷ��
	CC.ShowXY=0      --0 ����ʾ 1 ��ʾ

	--����Ϊ������ʾ��ʽ�Ĳ���

	CC.RowPixel=4         -- ÿ���ֵļ��������

	CC.MenuBorderPixel=5  -- �˵����ܱ߿�������������Ҳ���ڻ����ַ�����box������������

	if CONFIG.Type==0 then      --320*240��ʾ��ʽ
		CC.DefaultFont=16

		CC.StartMenuFontSize=16  --��ʼ�˵��ֺ�

		CC.NewGameFontSize =16   --����Ϸ����ѡ���ֺ�

		CC.MainMenuX=10;         --���˵���ʼ����
		CC.MainMenuY=10;

		CC.GameOverX=90;
		CC.GameOverY=65;

        CC.PersonStateRowPixel= 1;    --��ʾ����״̬�м������

	elseif CONFIG.Type==1 then  --640*480��ʾ��ʽ
		CC.DefaultFont=24;

		CC.StartMenuFontSize=32;

		CC.NewGameFontSize =24;

		CC.MainMenuX=10;
		CC.MainMenuY=10;

		CC.GameOverX=255;
		CC.GameOverY=165;

        CC.PersonStateRowPixel= 4;  --��ʾ����״̬�м������

	end

    CC.StartMenuY=CC.ScreenH-3*(CC.StartMenuFontSize+CC.RowPixel)-20;
	CC.NewGameY=CC.ScreenH-4*(CC.NewGameFontSize+CC.RowPixel)-10;

	--�Ӳ˵��Ŀ�ʼ����
	CC.MainSubMenuX=CC.MainMenuX+2*CC.MenuBorderPixel+2*CC.DefaultFont+5;       --���˵�Ϊ��������
	CC.MainSubMenuY=CC.MainMenuY;

	--�����Ӳ˵���ʼ����
	CC.MainSubMenuX2=CC.MainSubMenuX+2*CC.MenuBorderPixel+4*CC.DefaultFont+5;   --�Ӳ˵�Ϊ�ĸ��ַ�

	CC.SingleLineHeight=CC.DefaultFont+2*CC.MenuBorderPixel+5;  --����ĵ����ַ���

	------------------------����Ϊ��Ʒ�˵�����
	if CONFIG.Type==0 then
		CC.ThingFontSize = 16;

		CC.ThingPicWidth=40;    --��ƷͼƬ���
		CC.ThingPicHeight=40;

		CC.MenuThingXnum=5      --һ����ʾ������Ʒ
		CC.MenuThingYnum=3      --��Ʒ��ʾ����

		CC.ThingGapOut=10;      --��Ʒͼ����ʾ��������
		CC.ThingGapIn=5;        --��Ʒͼ����ʾ�м���

	elseif CONFIG.Type==1 then

		CC.ThingFontSize = 24;  --

		CC.ThingPicWidth=40;    --��ƷͼƬ���
		CC.ThingPicHeight=40;

		CC.MenuThingXnum=10      --һ����ʾ������Ʒ
		CC.MenuThingYnum=5      --��Ʒ��ʾ����

		CC.ThingGapOut=10;      --��Ʒͼ����ʾ��������
		CC.ThingGapIn=10;        --��Ʒͼ����ʾ�м���
	end


    --�����ӽǷ�Χ�������˷�Χ��ֻ�ƶ����ǣ��������ƶ��ˡ�Ҳ�������ǲ�����Ļ������
	if CONFIG.Type==0 then      --320*240��ʾ��ʽ
        CC.SceneXMin=12
        CC.SceneYMin=12
        CC.SceneXMax=45;
        CC.SceneYMax=45;
	elseif CONFIG.Type==1 then
        CC.SceneXMin=11
        CC.SceneYMin=11
        CC.SceneXMax=47;
        CC.SceneYMax=47;
	end

	CC.SceneFlagPic={2749,2846}    --������ͼ�����ĵ���ͼ��š�

	if CONFIG.FastShowScreen==0 then
        CC.ShowFlag=1;                 --0 ����ʾ���Ķ��� 1 ��ʾ������ʾ���Ķ����������ӳ��������ǲ���ʱ����ʾ�ٶ�
		if CONFIG.Type==1 then
            CC.AutoWarShowHead=1;          --1 ս��ʱһֱ��ʾͷ�� 0 ����ʾ�������Ϊ1����ս��ʱ���ػ�������Ļ���ή����ʾ�ٶȡ�
		else
		    CC.AutoWarShowHead=0;
		end
	else
        CC.ShowFlag=0;
		CC.AutoWarShowHead=0;
	end

    CC.LoadThingPic=1           --��ȡ��Ʒ��ͼ��ʽ 0 ��mmap/smap/wmap�ж�ȡ  1 ��ȡ������thing.idx/grp
	CC.StartThingPic=0          --��Ʒ��ͼ��mmap/smap/wmap�е���ʼ��š�CC.LoadThingPic=0��Ч


end
