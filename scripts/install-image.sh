#!/bin/sh

cd $sourcedir/$version

make installkernel DESTDIR=$mountdir TARGET=$arch
make installworld DESTDIR=$mountdir TARGET=$arch
make distribution DESTDIR=$mountdir TARGET=$arch

cat > $mountdir/etc/fstab << EOF
/dev/ada0s1a	/	ufs	rw,noatime	1	1
/dev/ada0s1b	none	swap	sw		0	0
EOF

cat > $mountdir/etc/rc.conf << EOF
EOF

sync && sleep 60

gpart bootcode -b $mountdir/boot/boot0 md${u}

gpart bootcode -b $mountdir/boot/boot md${u}s1

sync && sleep 10
