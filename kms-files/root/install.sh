#!/bin/sh

/root/xorgmerge

ap="/root/addpackage.sh"
packets="automake111 xorg-macros portmaster xorg-server seamonkey blender stellarium mesa-demos"

#no matter that these packets not exactly latest ones.
pm="/usr/local/sbin/portmaster -yDGB --no-confirm"
#step 1 - preinstall;
for i in $packets ; do
    $ap $i
done;

#step 2 - upgrade ports with portmaster

$pm -a >> /root/portmaster.log

$pm x11-wm/openbox
$pm x11/xterm
$pm x11-drivers/xf86-input-mouse
$pm x11-drivers/xf86-input-keyboard
$pm x11-drivers/xf86-video-intel-kms

