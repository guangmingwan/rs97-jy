--function oldevent_65()

    if instruct_4(191,1,0) ==false then    --  4(4):是否使用物品[一颗头颅]？是则跳转到:Label0
        do return; end
    end    --:Label0

    instruct_32(191,-1);   --  32(20):物品[一颗头颅]+[-1]
    instruct_1(224,0,1);   --  1(1):[WWW]说: 谢前辈，*这是成崑的项上人头．*成崑作恶多端已遭天谴．
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(225,13,0);   --  1(1):[谢逊]说: 是吗？哈！哈！*成崑啊，成崑！*你作恶多端终遭天谴，*但，可惜啊，可惜！*我不能亲手杀了你．　　　
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(226,0,1);   --  1(1):[WWW]说: 成崑一事已了，谢大侠还是*尽快回到中土，以免明教四*分五裂．
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(227,13,0);   --  1(1):[谢逊]说: 少侠为我明教付出许多，谢*某感激不尽．待我将这料里*完毕後，定当赶回明教．*到时还望少侠前来我明教作*客．**唉，成崑已死，这把屠龙刀*我留着还有什麽用呢？*屠龙刀就送给你好了．
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_2(117,1);   --  2(2):得到物品[屠龙刀][1]
    instruct_3(-2,-2,-2,-2,66,-1,-2,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:当前场景事件编号
    instruct_3(-2,3,-2,-2,-1,-1,67,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [3]
--end

