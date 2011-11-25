#!/bin/sh

sourcedir="../sources"

builddir="../builds"

statesdir="../states"

configdir="../config"

arch="amd64"

mountpath="../mount/$version-${arch}${mod}"

[ -d "$sourcedir" ] || mkdir -p "$sourcedir"

[ -d "$mountpath" ] || mkdir -p "$mountpath"

mountdir=`cd $mountpath && pwd`

[ -d "$builddir/$version" ] || mkdir -p "$builddir/$version"

[ -d "$statesdir/$version" ] || mkdir -p "$statesdir/$version"

svnremver=`cd $sourcedir/$version && svn info | grep "Revision" | awk '{split($0, f, " "); print f[2];}' `

svnver=`cd $sourcedir/$version && svn info | grep "Last Changed Rev" | awk '{split($0, f, " "); print f[4];}' `

commonfilename="$builddir/$version/FreeBSD-${version}${mod}-$arch-r$svnver-`date +'%Y-%m-%d'`"

imagefile="$commonfilename.img"

imagevdi="$commonfilename.vdi"

imagezip="$commonfilename.zip"

