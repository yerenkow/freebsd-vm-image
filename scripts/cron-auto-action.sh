#!/usr/local/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 DIR or $0 DIR MDNUM or $0 DIR MDNUM MODIFICATION"
    exit 0;
fi

OURDIR=`pwd`

echo $OURDIR;

version=$1
u=$1

if [ -n "$2" ]; then
u=$2
fi

mod=""
if [ -n "$3" ]; then
mod="$3"
fi

source common-scripts.sh

if [ -f $configdir/${version}${mod}.sh ]; then
    echo "Including custom overrides $configdir/${version}${mod}.sh ..."
    source $configdir/${version}${mod}.sh
    #this required if something has changed, like arch or path or else;
    source common-scripts.sh
fi

echo "Version: $version";

builtlock="$statesdir/$version/built-$arch-r${svnver}${mod}.OK"
imagelock="$statesdir/$version/image-$arch-r${svnver}${mod}.OK"
vdilock="$statesdir/$version/vdi-$arch-r${svnver}${mod}.OK"

if [ -n "$svnver" ]; then

#step 1; Check if we have build system;
if [ ! -f $builtlock ]; then
    #build here;
if [ -f $configdir/build-distrib-${version}${mod}.sh ]; then
   source $configdir/build-distrib-${version}${mod}.sh
else
    source build-distrib.sh
fi
    cd $OURDIR
    touch $builtlock
fi

#step 2; Check if we have created basic image
if [ ! -f $imagelock ]; then
    #create it, install there system;
    source create-image.sh
    cd $OURDIR
    source install-image.sh
    cd $OURDIR
    source detach-image.sh
    cd $OURDIR
    touch $imagelock
fi

#step 2.5, not mandatory, custom post-install actions
if [ -f $configdir/post-install-${version}${mod}.sh ]; then
postinstalllock="$statesdir/$version/post-$arch-r${svnver}${mod}.OK"
    if [ ! -f $postinstalllock ]; then
	source attach-image.sh
	cd $OURDIR
	source $configdir/post-install-${version}${mod}.sh
	cd $OURDIR
	source detach-image.sh
	cd $OURDIR
	touch $postinstalllock
    fi
fi

#step 3; Check if we converted and packed it

if [ ! -f $vdilock ]; then
    source convert-images.sh
    cd $OURDIR
    touch $vdilock
fi

fi

#step 4; If all went OK, or failed, anyway - update sources.
source checkout-version.sh
