#!/bin/sh

patchfile="all.11.0.mod.patch"
#patchurl="http://people.freebsd.org/~kib/drm/$patchfile"

#rm -fr $sourcedir/$version-${mod}
#cp -r $sourcedir/$version $sourcedir/$version-${mod}
cd $sourcedir/$version${mod}
#cp ../../kms-files/${patchfile}

#patch -f -p1 < $patchfile

#todo apply additional patches;

nice make -j 4 buildworld TARGET=$arch >& buildworld${arch}.log

nice make -j 4 buildkernel TARGET=$arch >& buildkernel${arch}.log

