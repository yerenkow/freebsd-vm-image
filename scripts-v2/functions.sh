#!/bin/sh

createPartition(){
#1 - num, 2 - disk, 3 - label
gpart add -s 7500m -t freebsd -i ${1} ${2}
#gpart create -s BSD ${2}s${1}
gpart add -s 7100m -t freebsd-ufs -i 1 ${2}s${1}
#if we switch to GPT - label changing in separate call - since it could be faulted
#gpart modify -i 1 -l ${3} ${2}s${1}
gpart add -t freebsd-swap -i 2 ${2}s${1}
#gpart modify -i 2 -l ${4} ${2}s${1}

dd if=/dev/zero of=/dev/${2}s${1}a bs=128m
dd if=/dev/zero of=/dev/${2}s${1}b bs=128m

newfs -Uj /dev/${2}s${1}a
}

destroyPartition(){
#1 - num, 2 - disk
    gpart delete -i 2 ${2}s${1}
    gpart delete -i 1 ${2}s${1}
    gpart delete -i ${1} ${2}
}

isStateFilePresent(){
#1 - statedirpath, 2 - revision, 3 - action, 4 - appendix
    if [ -e "$1$2$3$4" ] ; then
    echo "true"
    else
    echo "false"
    fi
}
createStateFile(){
#1 - statedirpath, 2 - revision, 3 - action, 4 - appendix
    touch "$1$2$3"
}

getSvnRevision(){
#1 - dirpath
svnrev=`cd $1 && svn info | grep "Last Changed Rev" | awk '{split($0, f, " "); print f[4];}' `
echo $svnrev
}

svnUpdateDir(){
#ignoring output, like we are in a ideal world
    st="`pwd`"
    cd $1 && svn up
    cd $st
}

dirName(){
    basename `realpath $1`
}

updatePortsTree(){
portsnap -p $1 -d $2 fetch update
}

buildWorld(){
    st="`pwd`"
    cd $1 && nice make -j 4 buildworld TARGET=$2
    cd $st
}

buildKernel(){
    st="`pwd`"
    cd $1 && nice make -j 4 buildkernel TARGET=$2
    cd $st
}

installAll(){
    st="`pwd`"
    cd $1 && nice make installworld installkernel distribution TARGET=$2 DESTDIR=$3
    cd $st
}

mountDisk(){
#1 - num, 2 - disk, 3 - path
#todo think about label mount?...
    mount -o noatime /dev/${2}s${1}a ${3}
}

writeBootCode(){
#1 - num, 2 - disk, 3 - mountdir
    gpart bootcode -b ${3}/boot/boot ${2}s${1}
}

mergeSimpleDirs(){
#1 - src, 2 - mountdir
    st="`pwd`"
    cd $1 && cp -r ./ $2
    cd $st
}


