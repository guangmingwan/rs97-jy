


---��ģ���Ŷ�JYMain.lua ���޸ĺ����䡣

--������������ģ�����������޸�ԭʼJYMain.Lua�ļ���
--����һ��������¼�������
--1. SetModify������   �ú�������Ϸ��ʼʱ���ã������ڴ��޸�ԭ�е����ݣ��Լ��ض���ԭ�еĺ�������ʵ�ֶ�ԭ�к������޸ġ�
--                    �����Ϳ��Ի�������ԭʼ�ĺ���
--2. ԭ�к��������غ����� SetModify�����صĺ������ڴ˴����������޸�JYMain.lua�ļ����������޸Ĳ����ض��庯������ʽ��
--3. �µ���Ʒʹ�ú�����
--4. �µĳ����¼�������





--��jymain���޸ģ��Լ������µ���Ʒ�����ͳ����¼�������
--ע��������Զ���ȫ�̱�����
function SetModify()

   --����һ�����庯�������ӡ����������޸����˵��е�ϵͳ�˵�����������Ϸ�����п�����Ч�Ĺ��ܡ�
   --ԭ��ֻ����jyconst.lua��ͨ������������ǰ���ƣ���������ʵʱ���ơ�
   Menu_System_old=Menu_System;         --����ԭʼ����������µĺ�����Ҫ�������Ե���ԭʼ������
   Menu_System=Menu_System_new;

   --�ڴ˶���������Ʒ��û�ж���ľ�����ȱʡ��Ʒ����
    JY.ThingUseFunction[182]=Show_Position;     --���̺���
	JY.ThingUseFunction[0]=newThing_0;   --�ı�ԭ�������صĹ���Ϊ���������������书��
	JY.ThingUseFunction[2]=newThing_2;

  --�ڴ˿��Զ���ʹ�����¼������ĳ���
    JY.SceneNewEventFunction[1]=newSceneEvent_1;          --�µĺ����ջ�¼�������

end


--�µ�ϵͳ�Ӳ˵������ӿ������ֺ���Ч
function Menu_System_new()
	local menu={
	             {"��ȡ����",Menu_ReadRecord,1},
                 {"�������",Menu_SaveRecord,1},
				 {"�ر�����",Menu_SetMusic,1},
				 {"�ر���Ч",Menu_SetSound,1},
				 {"ȫ���л�",Menu_FullScreen,1},
                 {"�뿪��Ϸ",Menu_Exit,1},   };

    if JY.EnableMusic==0 then
	    menu[3][1]="������";
	end

	if JY.EnableSound==0 then
	    menu[4][1]="����Ч";
    end


    local r=ShowMenu(menu,6,0,CC.MainSubMenuX,CC.MainSubMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
    if r == 0 then
        return 0;
    elseif r<0 then   --Ҫ�˳�ȫ���˵���
        return 1;
 	end
end

function Menu_FullScreen()
    lib.FullScreen();
	lib.Debug("finish fullscreen");
end

function Menu_SetMusic()
    if JY.EnableMusic==0 then
	    JY.EnableMusic=1;
		PlayMIDI(JY.CurrentMIDI);
	else
	    JY.EnableMusic=0;
		lib.PlayMIDI("");
	end
	return 1;
end

function Menu_SetSound()
    if JY.EnableSound==0 then
	    JY.EnableSound=1;
	else
	    JY.EnableSound=0;
	end
	return 1;
end


----------------------------------------------------------------
---------------------------��Ʒʹ�ú���--------------------------


--���̺�������ʾ����ͼ����λ��
function Show_Position()
    if JY.Status ~=GAME_MMAP then
        return 0;
    end
    DrawStrBoxWaitKey(string.format("��ǰλ��(%d,%d)",JY.Base["��X"],JY.Base["��Y"]),C_ORANGE,CC.DefaultFont);
	return 1;
end


--���������ơ��Ⱥ��������һ���书
function newThing_0(id)
    if JY.Status ==GAME_WMAP then
	    return 0;
	end

    Cls();
    if DrawStrBoxYesNo(-1,-1,"�Ⱥ�������书�������������Ƿ����?",C_WHITE,CC.DefaultFont,1) == false then
        return 0;
    end
    Cls();
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,string.format("˭Ҫ����%s?",JY.Thing[id]["����"]),C_WHITE,CC.DefaultFont,1);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
    local r=SelectTeamMenu(CC.MainSubMenuX,nexty);
    if r<=0 then
	    return 0;
	end

	local pid=JY.Base["����" .. r];

	if JY.Person[pid]["�������ֵ"]<=50 then
	    return 0;
	end

	Cls();
    local numwugong=0;
    local menu={};
    for i=1,10 do
        local tmp=JY.Person[pid]["�书" .. i];
        if tmp>0 then
            menu[i]={JY.Wugong[tmp]["����"],nil,1};
            numwugong=numwugong+1;
        end
    end

    if numwugong==0 then
        return 0;
    end

    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,string.format("��ѡ��Ҫ���ǵ��书"),C_WHITE,CC.DefaultFont,1);

	r=ShowMenu(menu,numwugong,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE,C_WHITE);

    if r<=0 then
	    return 0;
    else
        local s=string.format("%s �����书 %s",JY.Person[pid]["����"],JY.Wugong[JY.Person[pid]["�书" .. r]]["����"]);
		DrawStrBoxWaitKey(s,C_WHITE,24);

		for i=r+1,10 do
		    JY.Person[pid]["�书" .. i-1]=JY.Person[pid]["�书" .. i];
		    JY.Person[pid]["�书�ȼ�" .. i-1]=JY.Person[pid]["�书�ȼ�" .. i];
		end

		local v,str=AddPersonAttrib(pid,"�������ֵ",-50);

	    DrawStrBoxWaitKey(str,C_WHITE,CC.DefaultFont);
        AddPersonAttrib(pid,"����",0);

        instruct_32(id,-1);
	end
    Cls();
	return 1;
end


--����Һ��ս��ʱ����ʹһ�������Ķ��Ѹ��������ָܻ�50%
function newThing_2(thingid)
    if JY.Status ~=GAME_WMAP then
	    return 0;
	end

	local menu={};
    local menunum=0;
    for i=0,WAR.PersonNum-1 do
	    menu[i+1]={JY.Person[WAR.Person[i]["������"]]["����"],nil,0}
        if WAR.Person[i]["�ҷ�"]==true and WAR.Person[i]["����"]==true then
            menu[i+1][3]=1;
			menunum=menunum+1;
        end
    end

	if menunum==0 then
	    return 0;
	end

	Cls();
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,string.format("��ѡ��Ҫ����Ķ���"),C_WHITE,CC.DefaultFont);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
    local r=ShowMenu(menu,WAR.PersonNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE,C_WHITE);
    Cls();
    if r>0 then
	    r=r-1;           --�˵�����ֵ�Ǵ�1��ʼ��ŵġ�
		WAR.Person[r]["����"]=false;
        local pid=WAR.Person[r]["������"];
        JY.Person[pid]["����"]=JY.Person[pid]["�������ֵ"];
        SetRevivePosition(r);
        instruct_32(thingid,-1);
        WarSetPerson();        --�����趨ս��λ��
	    return 1;
	else
	    return 0;
	end
end

--���ø�����ѵ�λ��Ϊ���뵱ǰʹ����Ʒ��ս����������Ŀ�λ
function  SetRevivePosition(id)
	local minDest=math.huge;
	local x,y;
	War_CalMoveStep(WAR.CurID,100,0);   --�����ƶ����� �������100��
	for i=0,CC.WarWidth-1 do
		for j=0,CC.WarHeight-1 do
			--local dest=Byte.get16(WAR.Map3,(j*CC.WarWidth+i)*2);
			local dest=GetWarMap(i,j,3); -- fix by http://www.txdx.net/viewthread.php?tid=422484&page=7&authorid=329645
			if dest>0 and dest <128 then
				if minDest>dest then
					minDest=dest;
					x=i;
					y=j;
				 elseif minDest==dest  then
					 if Rnd(2)==0 then
						x=i;
						y=j;
					end
				end
			end
		end
	end

	if minDest<math.huge then
        WAR.Person[id]["����X"]=x;
        WAR.Person[id]["����Y"]=y;
	end

end


------------------------------------------------------------------------------------------
-------�µĳ����¼�����ʵ��

--��ÿ������ÿ��D*����Ӧһ��lua�ļ����ڴ��ļ��д���ͬ�Ĵ�����ʽ���¼��仯���
--��������һ��ȱ�㣬������D*��Ҫ����ͬ�����¼���ô�죿һ���취����һ��lua�ļ��м�����dofile������һ����
--��һ���취����һ���Զ���ĳ����¼����������������жϲ�ͬ��D���ò�ͬ�ĺ�����


-------�µĺ����ջ�����¼�������
--���������ھɵĴ�����������������D*����˲���Ҫ��������һ��������
--�����ȫ�µĴ�������ֱ��ʹ��newCallEvent���ɡ�
--flag 1 �ո񴥷���2����Ʒ������3��·������
function newSceneEvent_1(flag)
    if JY.CurrentD<=18 then     --����ǰ��ŵ�D*����Ȼ���þɵĴ�����
        oldEventExecute(flag);
    else
        newCallEvent(flag);
	end
end


--�µ�ͨ���¼�������
function newCallEvent(flag)

    JY.CurrentEventType=flag;

	local eventnum;
	if flag==1 then
		eventnum=GetD(JY.SubScene,JY.CurrentD,2);
	elseif flag==2 then
		eventnum=GetD(JY.SubScene,JY.CurrentD,3);
	elseif flag==3 then
		eventnum=GetD(JY.SubScene,JY.CurrentD,4);
	end

    if eventnum>=0 then           --ֻ�д��ڻ����0ʱ�ŵ���lua�ļ���
	--���ո�����ʽ����Ҫ���õ�D*�����ļ�����Ȼ���������
		local eventfilename=string.format(CONFIG.NewEventPath .. "scene_%d_event_%d.lua",JY.SubScene,JY.CurrentD);
		dofile(eventfilename);
    end

    JY.CurrentEventType=-1;
end

