

-- 配置文件
--为了简化处理，配置文件也用lua编写
--保存C程序读取的参数和lua程序中需要经常调整的参数。lua的其他参数仍然放在jyconst.lua中

CONFIG={};

CONFIG.Debug=1;         --输出调试和错误信息，=0不输出 =1 输出信息在debug.txt和error.txt到当前目录

--窗口设置类别。小于640*480(最小为320*240) 设为0，大于等于640*480 设为1
--目前只做了这两个类别，其他分辨率虽然可用，信息都能够显示，但是显示效果不一定好看。
--如果想在其他分辨率下美化显示效果，可以自行在jyconst.lua中修改相应的数据
CONFIG.Type= 1;

CONFIG.Width  = 640;       -- 游戏图形窗口宽
CONFIG.Height = 480;      -- 游戏图形窗口宽

CONFIG.bpp  =16          -- 全屏时像素色深，一般为16或者32。在窗口模式时直接采用当前屏幕色深，此设置无效
                         -- 不支持8位色深。为提高速度，建议使用16位色深。
						 -- 24位未经过测试，不保证正确显示

CONFIG.FullScreen=0      -- 启动时是否全屏  1 全屏 0 窗口
CONFIG.EnableSound=1     -- 是否打开声音    1 打开 0 关闭   关闭了在游戏中无法打开

CONFIG.KeyRepeat=0       -- 是否激活键盘重复 0 不激活，只在走路菜单时键盘重复，1激活，包括对话的所有时候键盘均重复
CONFIG.KeyRepeatDelay =500;   --第一次键盘重复等待ms数
CONFIG.KeyRePeatInterval=30;  --一秒钟重复次数

CONFIG.XScale = 18    -- 贴图宽度的一半
CONFIG.YScale = 9     -- 贴图高度的一半


--设置各个数据文件的路径，如果是其他目录标志和windows不同的OS, 如linux，则改为合适的路径
CONFIG.DataPath="data\\";
CONFIG.PicturePath="pic\\";
CONFIG.SoundPath="sound\\";
CONFIG.ScriptPath="script\\";
CONFIG.OldEventPath=CONFIG.ScriptPath .. "oldevent\\";
CONFIG.NewEventPath=CONFIG.ScriptPath .. "newevent\\";
CONFIG.ScriptLuaPath="?.lua;script\?.lua;script/?.lua";        --用lua规则写的路径

CONFIG.JYMain_Lua=CONFIG.ScriptPath .. "jymain.lua";   --lua主程序名

--显示字体文件。如果是windows，可直接给出系统目录下的字体名。
--其他系统可以找个合适的truetype字体复制到游戏data或其他目录下，在这里给出路径和文件名
CONFIG.FontName="c:\\winnt\\fonts\\simsun.ttc";


--显示主地图x和y方向增加的贴图数，以保证所有贴图能全部显示
CONFIG.MMapAddX=2;
CONFIG.MMapAddY=2;
CONFIG.SMapAddX=2;
CONFIG.SMapAddY=16;
CONFIG.WMapAddX=2;
CONFIG.WMapAddY=16;

CONFIG.MusicVolume=16;            --设置播放音乐的音量(0-128)
CONFIG.SoundVolume=32;            --设置播放音效的音量(0-128)

local LargeMemory=0;             --设置内存使用方式 1 多使用内存，0 少使用内存

if LargeMemory==1 then
     --贴图缓存数量，一般500-1000。如果在debug.txt中经常出现"pic cache is full"，可以适当增加
    CONFIG.MAXCacheNum=1000;
	CONFIG.CleanMemory=0;         --场景切换时是否清理lua内存。0 不清理 1 清理
	CONFIG.LoadFullS=1;           --1 整个S*文件载入内存 0 只载入当前场景，由于S*有4M多，这样可以解决很多内存
else
    CONFIG.MAXCacheNum=500;
	CONFIG.CleanMemory=1;
	CONFIG.LoadFullS=0;
end
