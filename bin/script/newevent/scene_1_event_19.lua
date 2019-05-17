

--����1 ���Ϊ19��D*����


--�ȶ��屾�ļ�ʹ�õľֲ�����

--����
--���ڼ۸�����м۸�ģ�����ա�û�еģ������ҩƷ��һ����10�ɵļ۸��ա�
local function Menu_Sale()
    local Price={};
	Price[0]=1600;           --����������
	Price[2]=1000;           --����Һ
    Price[28]=600;           --����������
    Price[29]=700;           --ǧ����֥
    Price[34]=500;           --ǧ���˲�
    Price[35]=800;           --��ɽѩ��

	Cls();
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"��ѡ����Ҫ��������Ʒ",C_WHITE,CC.DefaultFont);
    lib.ShowSurface();
	lib.Delay(500);

	local thing={};
    local thingnum={};

    for i = 0,CC.MyThingNum-1 do
        thing[i]=JY.Base["��Ʒ" .. i+1];
        thingnum[i]=JY.Base["��Ʒ����" ..i+1];
    end

    local r=SelectThing(thing,thingnum);
	Cls();
    if r<0 then
	    return 0;
	end

    local value;
    if Price[r]==nil then
	    if JY.Thing[r]["����"]==3 then
	        value=10;
		else
            DrawStrBoxWaitKey("��Ǹ��������Ʒ���ǲ��ա�",C_WHITE,CC.DefaultFont);
			Cls();
			return 0;
		end
	else
	    value=Price[r];
	end

    if DrawStrBoxYesNo(-1,-1,string.format("%s��ֵ%s�����ӣ��Ƿ񵱵�?",JY.Thing[r]["����"],value),C_WHITE,CC.DefaultFont,1) == true then
        instruct_32(r,-1);                 --��Ʒ����1
        instruct_32(CC.MoneyID,value);     --��������
    end
	Cls();
	return 0;
end




local function Menu_Shop()
    TalkEx("�����������������û�еĲ�Ʒ����ӭѡ��",111,0);

	local ShopThing={ {0,2000},         --����������
	                  {2,1200},          --����Һ
					  {28,800},}         --����������

    local menu={};
	for i=1,3 do
	    menu[i]={};
	    menu[i][1]=string.format("%-12s %5d",JY.Thing[ShopThing[i][1]]["����"],ShopThing[i][2]);
        menu[i][2]=nil;
		menu[i][3]=1;
	end

    local r=ShowMenu(menu,3,0,CC.MainSubMenuX,CC.MainSubMenuY+CC.SingleLineHeight,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r>0 then
        if instruct_31(ShopThing[r][2])==false then
            TalkEx("�ǳ���Ǹ�������ϵ�Ǯ�ƺ�������",111,0);
        else
            instruct_32(CC.MoneyID,-ShopThing[r][2]);     --���Ӽ���
            instruct_32(ShopThing[r][1],1);           --��Ʒ����
            TalkEx("��ӭ�´ι��٣�",111,0);
        end
    end

end


local function Menu_Task()
    TalkEx("��ӭ����Ӷ���лᣬ������ѡ������",111,0);

    local menu={ {"ȥɳĮ����֩���",nil,1,61,50},    --�����������Ϊս����ź�Ӯ��õ���Ǯ��
	             {"ȥ�Ϻ�ɱ������",nil,1,89,100},
				 {"ȥ����ɽ��ѩ��",nil,1,6,200},
				 };

    local r=ShowMenu(menu,3,0,CC.MainSubMenuX,CC.MainSubMenuY+CC.SingleLineHeight,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r>0 then
        TalkEx("ף����ˣ�",111,0);
		if WarMain(menu[r][4],1)==true then
		    instruct_13();
            DrawStrBoxWaitKey(string.format("����ս��ʤ�������%d�����ӣ�",menu[r][5]),C_WHITE,CC.DefaultFont);
            instruct_32(CC.MoneyID,menu[r][5]);     --���Ӽ���
		else
		    instruct_13();
            DrawStrBoxWaitKey("ս��ʧ�ܣ���Ǹû�����ӿ�����",C_WHITE,CC.DefaultFont);
		end
	end

    Cls();

end



--ȥ������ջ
local function Menu_Go()
    TalkEx("������ѡ��Ҫȥ�Ŀ�ջ��",111,0);
    local Address={ {3,21,50},           --����Ϊ����id�������ڳ�����XY���ꡣע�������������ǿյء�
	                {40,26,43},
					{60,26,42},
                    {61,23,49}, };

    local menu={};
	for i=1,4 do
	    menu[i]={ JY.Scene[Address[i][1]]["����"],nil,1};
	end

    local r=ShowMenu(menu,4,0,200,200,0,0,1,1,24,C_ORANGE, C_WHITE);

    if r>0 then

		lib.ShowSlow(50,1);
		ChangeSMap(Address[r][1],Address[r][2],Address[r][3],0);       --�����³���
		--�����µ�����ͼ���꣬�Ա���³�����ȷ������
		ChangeMMap(JY.Scene[JY.SubScene]["�⾰���X1"],JY.Scene[JY.SubScene]["�⾰���Y1"]+1,0);

        lib.ShowSlow(50,0);
    end;

    Cls();
    return 1;
end



-- �������¼�ִ��

--���¼�ִ��ʱ�����ȸ���JY.CurrentEventType����ȷ���¼�������ʽ 1 �ո񴥷� 2 ��Ʒ���� 3·������
--Ȼ�����JY.SubScene ��JY.CurrentD �õ���ǰ�¼��͵�ǰD* ���ݡ���ȡD*��Ӧ�����¼���ֵ��
--���������ֵ���ж��¼�Ӧ��ִ�еĶ�����Ȼ������Ҫ�����޸Ĵ�ֵ���ﵽ�����¼�������Ŀ��


    if JY.CurrentEventType~=1 then
	    return ;
	end

    local v=GetD(JY.SubScene,JY.CurrentD,2);       --�õ��ո񴥷��¼���ֵ

	if v<0 then
	    return ;
	elseif v==0 then
        Talk("�ף���ղŻ������棬��ôͻȻ�͵��������ˣ�Ī����ʹ���˴�˵�е����л�Ӱ֮����",0);
		TalkEx("�������㿴���ˡ�����ΤС���ĸ��Τ�󱦣��������������������Ժܶ��˶����ϴ�ġ�",111,0);
        Talk("���Ȼ������磬��ô�����ǲ��Ǳ�������ôһ����أ�",0);
		TalkEx("�ǵ�Ȼ��������Щ��ɫҲֻ�ܺ�����ˣ�û���Ļ�ͬ�������ڽ����ϻ졣�������ṩ�Ķ������������Ҫ��Ҫ���Կ���",111,0);
        Talk("�㶼�ṩ��Щ������񰡣�����һ����",0);
		TalkEx("�ṩ���¼��ַ��񣺵䵱���񣬵����г���Ӷ���лᣬ˲Ϣǧ��",111,0);
        Talk("�ǵ䵱������ǵ����ˣ�",0);
		TalkEx("�ԣ��������ò��ŵĶ����������Խ��������ﵱ���������������������޻صġ���Ȼ����Щ���������ǲ��յġ�����ֻ��ҩƷ��Ҳ���յ����г����۵���Ʒ",111,0);
        Talk("�����г���ʲô��Ī���Ǻ��У�",0);
		TalkEx("�꣡С���㣬���Ĺٲ����ˡ������ṩ�����ϼ�������������Ʒ��",111,0);
        Talk("��Ӷ���л��Ǹ�ʲô�ģ��ѵ�Ҳ�ܽ���������",0);
		TalkEx("�԰������ǲ��Ǿ����е�ûǮ�������ǿ��Ը����ṩ��Ǯ�Ļ��ᣬ������������������Ǯ��ͬʱ˳����������",111,0);
        Talk("�е�����˲Ϣǧ���Ǹ�ʲô�ģ�",0);
		TalkEx("�������Զ�ܵ������������ҿ��Ը�������ṩȥ������ջ�ķ�����һգ�۵Ĺ��򣬾͵���������ջ�ˣ������գ�",111,0);

        SetD(JY.SubScene,JY.CurrentD,2,1)     --���ÿո񴥷��¼���ֵ
    elseif v==1 then
		TalkEx("Ҫ��Ҫ�������ṩ���������",111,0);
        Talk("��������������ʶһ������������",0);
        Cls();

		local menu={ {"�䵱����",Menu_Sale,1},
		             {"�����г�",Menu_Shop,1},
		             {"Ӷ���л�",Menu_Task,1},
					 {"˲Ϣǧ��",Menu_Go,1},}
        local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
        local r=ShowMenu(menu,4,0,CC.MainSubMenuY,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE,C_WHITE);
		Cls();

	end
