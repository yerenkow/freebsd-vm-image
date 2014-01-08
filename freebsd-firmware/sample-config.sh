#!/bin/sh

zpool="zbuilder"
zpoolmnt="/zbuilder"
srcdir="src/src-10-stable"
clonedir="src/src-10-stable-clone"
#handy to have chosen md num for build.
md="7"
#mount point to install there, used as DESTDIR
mnt="/mnt"

imgsize=800
#type="mbr"
type="gpt"

#in case you planning use of ZFS with F-FW, you maybe need to have directory in root
#zfsdir=zstorage