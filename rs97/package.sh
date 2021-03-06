#!/bin/bash

mkdir -p bin
find . -name ".DS_Store" -exec rm {} \;  
rm -rf ipkg/media/mmcblk0p3/games/sdljy/*
patchelf ../bin/sdljy.bin --set-rpath '/home/retrofw/games/sdljy/libs.dingux'

readelf -d ../bin/sdljy.bin|grep runpath
cp sdljy.dge ipkg/media/mmcblk0p3/games/sdljy/
cp sdljy.png ipkg/media/mmcblk0p3/games/sdljy/
cp freepats.cfg ipkg/media/mmcblk0p3/games/sdljy/
cp timidity.cfg ipkg/media/mmcblk0p3/games/sdljy/
cp -R ../bin/* ipkg/media/mmcblk0p3/games/sdljy/
cp -R freepats ipkg/media/mmcblk0p3/games/sdljy/

cp -R libs.dingux ipkg/media/mmcblk0p3/games/sdljy/


cd ipkg

tar -czf control.tar.gz control --owner=0 --group=0
tar -czf data.tar.gz home media --owner=0 --group=0
ar rv sdljy.ipk control.tar.gz data.tar.gz debian-binary

cd ..

mv ipkg/sdljy.ipk bin/
rm ipkg/control.tar.gz
rm ipkg/data.tar.gz
#rm ipkg/home/retrofw/games/sdljy/sdljy.dge
#rm -R ipkg/home/retrofw/games/sdljy/res
