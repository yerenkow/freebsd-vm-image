#!/bin/sh


f="$1.vmdk"
g="$1-flat.vmdk"


cylinders="1625"
heads="16"
sectors="63"


#cid - is most important here, as it's random ID of our image.
cid=`dd if=/dev/random bs=1k count=1 | md5 | cut -c 1-8 `
echo $cid

echo "# Disk DescriptorFile
version=1
encoding=\"UTF-8\"" >> $f
echo "CID=$cid" >> $f
echo "parentCID=ffffffff
isNativeSnapshot=\"no\"
createType=\"monolithicFlat\"" >> $f

echo "" >> $f
echo "RW 1638400 FLAT \"${1}-flat.vmdk\" 0" >> $f

echo "" >> $f
echo "ddb.toolsVersion = \"9216\"
ddb.virtualHWVersion = \"8\"" >> $f
#long ID should be random too (probably), I found that four times cid - works just fine.
echo "ddb.uuid.longContentID=\"$cid$cid$cid$cid\"" >> $f
echo "ddb.geometry.cylinders=\"$cylinders\""  >> $f
echo "ddb.geometry.heads=\"$heads\""  >> $f
echo "ddb.geometry.sectors=\"$sectors\""  >> $f
echo "ddb.adapterType=\"lsilogic\"" >> $f
#you can find that we completely ignoring all other params - they are or unimportant, or will re-generate upon image import.
