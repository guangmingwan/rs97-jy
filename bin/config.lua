

-- �����ļ�
--Ϊ�˼򻯴��������ļ�Ҳ��lua��д
--����C�����ȡ�Ĳ�����lua��������Ҫ���������Ĳ�����lua������������Ȼ����jyconst.lua��

CONFIG={};

CONFIG.Debug=1;         --������Ժʹ�����Ϣ��=0����� =1 �����Ϣ��debug.txt��error.txt����ǰĿ¼

--�����������С��640*480(��СΪ320*240) ��Ϊ0�����ڵ���640*480 ��Ϊ1
--Ŀǰֻ������������������ֱ�����Ȼ���ã���Ϣ���ܹ���ʾ��������ʾЧ����һ���ÿ���
--������������ֱ�����������ʾЧ��������������jyconst.lua���޸���Ӧ������
CONFIG.Type= 1;

CONFIG.Width  = 640;       -- ��Ϸͼ�δ��ڿ�
CONFIG.Height = 480;      -- ��Ϸͼ�δ��ڿ�

CONFIG.bpp  =16          -- ȫ��ʱ����ɫ�һ��Ϊ16����32���ڴ���ģʽʱֱ�Ӳ��õ�ǰ��Ļɫ���������Ч
                         -- ��֧��8λɫ�Ϊ����ٶȣ�����ʹ��16λɫ�
						 -- 24λδ�������ԣ�����֤��ȷ��ʾ

CONFIG.FullScreen=0      -- ����ʱ�Ƿ�ȫ��  1 ȫ�� 0 ����
CONFIG.EnableSound=1     -- �Ƿ������    1 �� 0 �ر�   �ر�������Ϸ���޷���

CONFIG.KeyRepeat=0       -- �Ƿ񼤻�����ظ� 0 �����ֻ����·�˵�ʱ�����ظ���1��������Ի�������ʱ����̾��ظ�
CONFIG.KeyRepeatDelay =500;   --��һ�μ����ظ��ȴ�ms��
CONFIG.KeyRePeatInterval=30;  --һ�����ظ�����

CONFIG.XScale = 18    -- ��ͼ��ȵ�һ��
CONFIG.YScale = 9     -- ��ͼ�߶ȵ�һ��


--���ø��������ļ���·�������������Ŀ¼��־��windows��ͬ��OS, ��linux�����Ϊ���ʵ�·��
CONFIG.DataPath="data\\";
CONFIG.PicturePath="pic\\";
CONFIG.SoundPath="sound\\";
CONFIG.ScriptPath="script\\";
CONFIG.OldEventPath=CONFIG.ScriptPath .. "oldevent\\";
CONFIG.NewEventPath=CONFIG.ScriptPath .. "newevent\\";
CONFIG.ScriptLuaPath="?.lua;script\?.lua;script/?.lua";        --��lua����д��·��

CONFIG.JYMain_Lua=CONFIG.ScriptPath .. "jymain.lua";   --lua��������

--��ʾ�����ļ��������windows����ֱ�Ӹ���ϵͳĿ¼�µ���������
--����ϵͳ�����Ҹ����ʵ�truetype���帴�Ƶ���Ϸdata������Ŀ¼�£����������·�����ļ���
CONFIG.FontName="c:\\winnt\\fonts\\simsun.ttc";


--��ʾ����ͼx��y�������ӵ���ͼ�����Ա�֤������ͼ��ȫ����ʾ
CONFIG.MMapAddX=2;
CONFIG.MMapAddY=2;
CONFIG.SMapAddX=2;
CONFIG.SMapAddY=16;
CONFIG.WMapAddX=2;
CONFIG.WMapAddY=16;

CONFIG.MusicVolume=16;            --���ò������ֵ�����(0-128)
CONFIG.SoundVolume=32;            --���ò�����Ч������(0-128)

local LargeMemory=0;             --�����ڴ�ʹ�÷�ʽ 1 ��ʹ���ڴ棬0 ��ʹ���ڴ�

if LargeMemory==1 then
     --��ͼ����������һ��500-1000�������debug.txt�о�������"pic cache is full"�������ʵ�����
    CONFIG.MAXCacheNum=1000;
	CONFIG.CleanMemory=0;         --�����л�ʱ�Ƿ�����lua�ڴ档0 ������ 1 ����
	CONFIG.LoadFullS=1;           --1 ����S*�ļ������ڴ� 0 ֻ���뵱ǰ����������S*��4M�࣬�������Խ���ܶ��ڴ�
else
    CONFIG.MAXCacheNum=500;
	CONFIG.CleanMemory=1;
	CONFIG.LoadFullS=0;
end
