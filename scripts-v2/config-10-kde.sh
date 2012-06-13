#!/bin/sh


partition="37"
disk="ada0"
sourcedir="`realpath /zstorage/testenv/sources/10`"
echo $sourcedir
portstree="`realpath /zstorage/testenv/portstree`"
portsnap="`realpath /zstorage/testenv/portsnap`"
codename="10-i386-kde"
target="i386"
srcpatchdirs="" #use empty if there's none
simplemergedir="`realpath /zstorage/testenv/kms-files`"
mergedirs="`realpath /zstorage/testenv/xorg-dev`" #separated by space, all this dirs goes to /root. If you need move them - embed mv to installation script
installscript="/root/install.sh"
statedir="/zstorage/testenv/newstates/" #trailing slash please;
mountdir="/zstorage/testenv/mount/10-i386"
