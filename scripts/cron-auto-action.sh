#!/usr/local/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 DIR  or $0 DIR MDNUM"
    exit
fi

OURDIR=`pwd`

echo $OURDIR

version=$1
u=$1

if [ -n "$2" ]; then
u=$2
fi

source common-scripts.sh

builtlock="$statesdir/$version/built-r${svnver}.OK"
imagelock="$statesdir/$version/image-r${svnver}.OK"
vdilock="$statesdir/$version/vdi-r${svnver}.OK"

#step 1; Check if we have build system;
if [ ! -f $builtlock ]; then
    #build here;
#    source build-distrib.sh
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

#step 3; Check if we converted and packed it

if [ ! -f $vdilock ]; then
    source convert-images.sh
    cd $OURDIR
    touch $vdilock
fi

#step 4; If all went OK, or failed, anyway - update sources.
source checkout-version.sh
