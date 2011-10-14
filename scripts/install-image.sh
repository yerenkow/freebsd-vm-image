#!/bin/sh

cd $sourcedir/$version

make installworld DESTDIR=$mountdir

make distribution DESTDIR=$mountdir

make installkernel DESTDIR=$mountdir

cat > $mountdir/etc/fstab << EOF
/dev/ada0p2	/	ufs	rw,noatime	1	1
/dev/ada0p3	none	swap	sw		0	0
EOF

cat > $mountdir/etc/rc.conf << EOF
EOF

sync && sleep 30

gpart bootcode -b $mountdir/boot/pmbr md$u

gpart bootcode -p $mountdir/boot/gptboot -i 1 md$u

sync && sleep 30

# just to make sure we can umount it now

