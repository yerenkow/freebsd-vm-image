#!/bin/sh

rm -f $imagevdi

VBoxManage convertfromraw $imagefile $imagevdi --format VDI

xz -9zk $imagevdi

zip -9 $imagezip $imagevdi

chmod +r $imagefile
chmod +r $imagevdi.xz
chmod +r $imagezip
