#!/bin/sh

cd $mountdir

echo "nameserver 8.8.8.8" > etc/resolv.conf


#env PACKAGESITE=ftp://ftp.freebsd.org/pub/FreeBSD/ports/i386/packages-9-stable/Latest/

cp -r ../../kms-files/ .

mkdir -p ./usr/ports

cp -r /usr/ports ./usr/ports

rootinstall="/root/install.sh"

chroot $mountdir $rootinstall


#/portsnap fetch extract

#pkg_add -r git

#cd /root

# python27
# pkg_add -r libpthread-stubs ???
# pkg_add -r automake111
# pkg_add -r xorg-macros
# pkg_add -r gconf 
# pkg_add -r bison flex
# pkg_add -r portmaster
# add xf86-intel-video
# add seamonkye via packet;
# add input mouse/kb
# add blender

# /usr/local/bin/git clone git://anongit.freedesktop.org/xorg/proto/dri2proto
# git://anongit.freedesktop.org/xorg/proto/glproto
# git://anongit.freedesktop.org/mesa/drm
# git://anongit.freedesktop.org/mesa/mesa

#fetch http://cgit.freedesktop.org/xorg/driver/xf86-video-intel/snapshot/xf86-video-intel-ab10008.tar.bz2
# tar xvf xf86-video-intel-ab10008.tar.bz2 

# cd drm
# fetch http://people.freebsd.org/~kib/drm/libdrm.1.patch
# patch -Np1 < libdrm.1.patch

# fetch http://people.freebsd.org/~miwi/xorg/xorgmerge

#apply patches;
