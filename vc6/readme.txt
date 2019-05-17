

          vc6编译说明  

1. 要在vc中选择多线程库，而不要选择多线程debug或者单线程库。
   因为其他dll都是多线程库。
2. 增加include的路径指向 ..\lua和..\sdl中的include.
3. 把..\lua\lib和..\sdl\lib中的lib文件加入到工程



