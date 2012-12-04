#!/bin/sh

zpool="zstorage"
zpoolmnt="/zstorage"
srcdir="src"
clonedir="src-clone"
buildtarget=" -j 8 -DNO_CLEAN -DNO_KERNELCLEAN buildworld buildkernel"
prebuildcurdir=`pwd`

getSvnRevision(){
# returns SVN rev as number from given dir
#1 - dirpath
svnrev=`cd $1 && svn info | grep "Last Changed Rev" | awk '{split($0, f, " "); print f[4];}' `
echo $svnrev
}

echo "Updating sources..."
cd ${zpoolmnt}/${srcdir} && svn up
cd $prebuildcurdir

rev=`getSvnRevision "${zpoolmnt}/${srcdir}"`

echo "Going to destroy our clone dir..."
#todo - make check for non-empty clonedir and zpool;
zfs destroy ${zpool}/${clonedir}
zfs snapshot ${zpool}/${srcdir}@${rev}
zfs clone ${zpool}/${srcdir}@${rev} ${zpool}/${clonedir}
echo "Building world && kernel..."
cd ${zpoolmnt}/${clonedir} && make ${buildtarget}
echo "Building image..."
cd $prebuildcurdir
./create-bsd-image
echo "Done!"
