#!/bin/sh

getSvnRevision(){
# returns SVN rev as number from given dir
#1 - dirpath
svnrev=`cd $1 && svn info | grep "Last Changed Rev" | awk '{split($0, f, " "); print f[4];}' `
echo $svnrev
}


createVmdkFiles() {
#1 - filename, w/o .vmdk extension
#2 - size, in MBs;

f="$1.vmdk"

heads="16"
sectors="63"
length="`bc -e '$2*1024*1024/512' -e quit`"
cylinders="`bc -e '${length}/${heads}/${sectors}' -e quit`"


#cid - is most important here, as it's random ID of our image.
cid=`dd if=/dev/random bs=1k count=1 | md5 | cut -c 1-8 `
echo $cid
#long ID should be random too (probably), I found that four times cid - works just fine.

echo "# Disk DescriptorFile
version=1
encoding=\"UTF-8\"
CID=$cid
parentCID=ffffffff
isNativeSnapshot=\"no\"
createType=\"monolithicFlat\"

RW ${length} FLAT \"${1}-flat.vmdk\" 0

ddb.toolsVersion = \"9216\"
ddb.virtualHWVersion = \"8\"
ddb.uuid.longContentID=\"$cid$cid$cid$cid\"
ddb.geometry.cylinders=\"$cylinders\"
ddb.geometry.heads=\"$heads\"
ddb.geometry.sectors=\"$sectors\"
ddb.adapterType=\"lsilogic\"" >> $f

}
