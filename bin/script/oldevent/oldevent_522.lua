--function oldevent_522()
    instruct_1(1827,96,0);   --  1(1):[???]说: 施主若要进入寺内，还请将*兵刃留下，待离寺时再归还*予你．
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_5(6,0) ==false then    --  5(5):是否选择战斗？是则跳转到:Label0
        instruct_1(1825,0,1);   --  1(1):[WWW]说: 好，好，我下回再来．
        instruct_0();   --  0(0)::空语句(清屏)
        do return; end
    end    --:Label0

    instruct_1(1828,0,1);   --  1(1):[WWW]说: 抱歉，恕难从命．
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_6(79,13,0,1) ==false then    --  6(6):战斗[79]是则跳转到:Label1
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_13();   --  13(D):重新显示场景
        instruct_1(1824,96,0);   --  1(1):[???]说: 请施主下山．
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(1822,0,1);   --  1(1):[WWW]说: 可是我还是想进去看看，*对不住了．
        instruct_0();   --  0(0)::空语句(清屏)
        do return; end
    end    --:Label1

    instruct_3(-2,3,0,0,-1,-1,-1,-1,-1,-1,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [3]
    instruct_3(-2,4,0,0,-1,-1,-1,-1,-1,-1,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [4]
    instruct_3(-2,5,0,0,-1,-1,-1,-1,-1,-1,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [5]
    instruct_3(-2,6,0,0,-1,-1,-1,-1,-1,-1,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [6]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_56(1);   --  56(38):提高声望值1
--end

