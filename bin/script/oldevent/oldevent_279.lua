--function oldevent_279()

    if instruct_4(161,1,0) ==false then    --  4(4):是否使用物品[红钥匙]？是则跳转到:Label0
        do return; end
    end    --:Label0

    instruct_17(-2,1,29,25,0);   --  17(11):修改场景贴图:当前场景层1坐标1D-19
    instruct_17(-2,1,29,24,3698);   --  17(11):修改场景贴图:当前场景层1坐标1D-18
    instruct_17(-2,1,28,24,3696);   --  17(11):修改场景贴图:当前场景层1坐标1C-18
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_3(-2,-2,-2,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);   --  3(3):修改事件定义:当前场景:当前场景事件编号
--end

