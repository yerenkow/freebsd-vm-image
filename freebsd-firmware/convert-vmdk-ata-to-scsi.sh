#!/bin/sh

# We take descriptor file, tweak it and our big flat image now SCSI :)
# Handy for Vmware, usable for VirtualBox.

f="$1"
g="$f.orig"

#cid - is most important here, as it's random ID of our image.
cid=`grep CID $g | grep -v parent | awk '{split($0, f, "="); print f[2];}' `

echo "# Disk DescriptorFile
version=1
encoding=\"UTF-8\"" >> $f
echo "CID=$cid" >> $f
echo "parentCID=ffffffff
isNativeSnapshot=\"no\"
createType=\"monolithicFlat\"" >> $f

echo "" >> $f
grep "RW " $g >> $f

echo "" >> $f

echo "ddb.toolsVersion = \"9216\"
ddb.virtualHWVersion = \"8\"" >> $f
#long ID should be random too (probably), I found that four times cid - works just fine.
echo "ddb.uuid.longContentID=\"$cid$cid$cid$cid\"" >> $f
grep "ddb.geometry" $g >> $f
echo "ddb.adapterType=\"lsilogic\"" >> $f
#you can find that we completely ignoring all other params - they are or unimportant, or will re-generate upon image import.
