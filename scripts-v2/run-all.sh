#!/bin/sh

. functions.sh

#step 0 - load config script, we get from there such variables:
#	num of partition to use
#	disk to use
#	src dir path
#	portstree path
#	portsnap db path
#	codename of build
#	src patches if exists
#	new system merge dir
#	new system packet installation script (to which we chroot)
#	fstab hints (what for we are building - da0, or ada0)

#step 1 - svn up needed source tree
#step 2 - update ports tree
#step 3 - check if any patches-trees we need, update them

#step4a - if there's no src patches, build world + kernel
#step4b - if there's src patches - copy src tree and apply all src patches before building;

#step5 - destroy disk partiton, init all from scratch

#step6 - install world to partition, create basic fstab
#step7 - write bootcode to partition

#	after this we have basically bootable and working clear OS.
#step8 - merge system
#step9 - chroot to installation script if any, catch output
#stepA - umount all, dump partition to file
#stepB - xz file


if [ ! -f "$1"  ] ; then
    echo "Usage example:";
    echo " $0 your-config-file.sh";
    exit 0;
fi

. $1

#TODO - FINISH ALL FOR OLD REVISION BEFORE UPDATE ANY SOURCES.
svnUpdateDir $sourcedir
sourceRev=$(getSvnRevision $sourcedir)
sourceDirName=$(dirName $sourcedir)
echo $sourceDirName
updatePortsTree $portstree $portsnap

workingSrcDir="$sourcedir"
sourceState="${sourceDirName}-${sourceRev}"
if [ ! -z "$srcpatchdirs" ] ; then
    echo "source patches"
    #todo make tempdir, copy sources, iterate by source pathes, svn up them and copy patches
    #change workingSrcDir;
    #change sourceState
else
    echo "no source patches, proceeding in $workingSrcDir dir."
fi

t=$(isStateFilePresent $statedir $sourceState "-world-built")
if [ "$t" != "true" ] ; then
    buildWorld $sourcedir $target
    createStateFile $statedir $sourceState "-world-built"
else
    echo "world already built, continue;"
fi

t=$(isStateFilePresent $statedir $sourceState "-kernel-built")
if [ "$t" != "true" ] ; then
    buildKernel $sourcedir $target
    createStateFile $statedir $sourceState "-kernel-built"
else
    echo "kernel already built, continue;"
fi


t=$(isStateFilePresent $statedir $sourceState "-newmedia")
if [ "$t" != "true" ] ; then
    destroyPartition $partition $disk
    createPartition $partition $disk 
    #labels as 3,4 args, only for gpt in future; "${disklabel}${sourceRev}" "${swaplabel}${sourceRev}"
    createStateFile $statedir $sourceState "-newmedia"
else
    echo "media already inited, continue;"
fi

#todo think about already mounted?...
mountDisk $partition $disk $mountdir

t=$(isStateFilePresent $statedir $sourceState "-wk-installed")
if [ "$t" != "true" ] ; then
    installAll $sourcedir $target $mountdir
    createStateFile $statedir $sourceState "-wk-installed"
else
    echo "all already installed, continue;"
fi

t=$(isStateFilePresent $statedir $sourceState "-bootcode")
if [ "$t" != "true" ] ; then
    writeBootCode $partition $disk $mountdir
    createStateFile $statedir $sourceState "-bootcode"
else
    echo "bootcode already installed, continue;"
fi

t=$(isStateFilePresent $statedir $sourceState "-simplemerge")
if [ "$t" != "true" ] ; then
    mergeSimpleDirs $simplemergedir $mountdir
    createStateFile $statedir $sourceState "-simplemerge"
else
    echo "simple merge already done, continue;"
fi

if [ ! -z "$mergedirs" ] ; then
    echo "mergedirs"
    for m in $mergedirs ; do
	svnUpdateDir $m
	targetDir="$mountdir/root/`basename $m`"
	mkdir -p $targetDir
	mergeSimpleDirs $m $targetDir
    done
    #todo make tempdir, copy sources, iterate by source pathes, svn up them and copy patches
    #change workingSrcDir;
    #change sourceState
else
    echo "no merge dirs, continue."
fi

mkdir -p ${mountdir}/usr/ports
mount -t nullfs ${portstree} ${mountdir}/usr/ports

chroot ${mountdir} ${installscript}

# umount $mountdir
