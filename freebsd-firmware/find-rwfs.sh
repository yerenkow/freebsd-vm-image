#!/bin/sh
#
# Simple script, which tries to find our partitions by their GPT labels and mount them

etcfs="/dev/gpt/etcfs"
varfs="/dev/gpt/varfs"
localfs="/dev/gpt/localfs"
missing_etc="yes"

if [ -e $etcfs ]; then
    /sbin/fsck -t ffs -y $etcfs
    /sbin/mount -o rw,noatime $etcfs /etc-rw
    /sbin/mount -t unionfs /etc-rw /etc
    missing_etc="no"
fi

if [ -e $varfs ]; then
    /sbin/fsck -t ffs -y $varfs
    /sbin/mount -o rw,noatime $etcfs /var-rw
    /sbin/mount -t unionfs /var-rw /var
fi

if [ -e $localfs -a ! -L /usr/local ]; then
    /sbin/fsck -t ffs -y $localfs
    /sbin/mount -o rw,noatime $localfs /usr/local
    if [ -e /usr/local/tmp -a ! -L /tmp ]; then
        /sbin/mount -t unionfs /usr/local/tmp /tmp
    fi
    if [ -e /usr/local/root-rw ]; then
        /sbin/mount -t unionfs /usr/local/root-rw /root
    fi
fi

if [ "${missing_etc}" = 'yes' ]; then
    if [ -e /usr/local/etc-md.img ]; then
        /sbin/mdconfig -af /usr/local/etc-md.img
        sleep 3
        if [ -e $etcfs ]; then
            /sbin/fsck -t ffs -y $etcfs
            /sbin/mount -o rw,noatime $etcfs /etc-rw
            /sbin/mount -t unionfs /etc-rw /etc
        fi
    fi
fi
