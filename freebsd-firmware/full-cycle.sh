#!/bin/sh
#
# Meant to be run like this:
# ./full-cycle.sh config.sh

. $1

. firmware-functions.sh

# todo probably move this optionally to config too
buildtarget1=" -DNO_CLEAN -DNO_KERNELCLEAN kernel-toolchain"
buildtarget2=" -j 8 -DNO_CLEAN -DNO_KERNELCLEAN buildworld"
buildtarget3=" -j 8 -DNO_CLEAN -DNO_KERNELCLEAN buildkernel"
prebuildcurdir=`pwd`

# Stage 1, update sources
echo "Updating sources..."
cd ${zpoolmnt}/${srcdir} && svn up
cd $prebuildcurdir

# Stage 2, get Revision
rev=`getSvnRevision "${zpoolmnt}/${srcdir}"`

# Stage 3, re-clone
echo "Going to destroy our clone dir..."
# todo - make check for non-empty clonedir and zpool;
zfs destroy ${zpool}/${clonedir}
zfs snapshot ${zpool}/${srcdir}@${rev}
zfs clone ${zpool}/${srcdir}@${rev} ${zpool}/${clonedir}

# Stage 4, build-all
echo "Building world && kernel..."
cd ${zpoolmnt}/${clonedir} && make ${buildtarget1} || exit 'Error happened at ${buildtarget1}'
cd ${zpoolmnt}/${clonedir} && make ${buildtarget2} || exit 'Error happened at ${buildtarget2}'
cd ${zpoolmnt}/${clonedir} && make ${buildtarget3} || exit 'Error happened at ${buildtarget3}'

# Stage 5, build-image itself
cd $prebuildcurdir
echo "Done, you can now build image."
