#!/bin/sh

VBoxManage convertfromraw $imagefile $imagevdi --format VDI

xz -9zk $imagevdi

#zip -9 $imagezip $imagevdi

chmod +x $imagevdi
