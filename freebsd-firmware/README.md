Info
====
This set of scripts used to produce FreeBSD image to be used in ReadOnly (RO) mode.
Since this is kind of similar to device's firmware, this project called

*FreeBSD Firmware*

Default login/password:
*root*/*testroot*

----------------

Goals
-----

1. Have base system in RO mode - less memory consumed by UFS (probably)
2. Validation and verification of base system - security side
3. Base system separation from configs and data
4. Easy of upgrade and rollback - change one image to another

Why not nanobsd?
----------------

### We have different goals from nanobsd
- Nanobsd encourage strip down all unnecessary, while FreeBSD-RO better be with DEBUG and docs.
- Nanobsd still require you to mount it in RW to make changes, while FreeBSD-RO will be pure RO
- Of course, both projects could be merged if it will be useful and makes sense.

How To
------

First, you need zpool where you'll checkout source tree.

    #zfs create zbuilder/src
    #zfs create zbuilder/src/src-stable-9
    #cd /zbuilder/src/src-stable-9
    #svn co svn://svn.freebsd.org/base/stable/9 .

Next, you need to create config file, for example called *config9.sh*
Best is to copy *sample-config.sh* and tweak it.
Here's content of *sample-config.sh*:

    #pool, where all happens
    zpool="zbuilder"
    #where pool mounted
    zpoolmnt="/zbuilder"

    #src dir, relative to pool path
    srcdir="src/src-10-stable"

    #clone dir, relative to pool path
    clonedir="src/src-10-stable-clone"

    #md number, to provide independent builds
    md="7"

    #mount point, to provide independent builds
    mnt="/mnt"

    #future changes could require tweak this
    imgsize=800

    # you better stick to GPT, if you not have faulty BIOS
    #type="mbr"
    type="gpt"

After this, you ready to build sources

    #./full-cycle.sh config9.sh

If all went good, you'll get world & kernel built.
If not - eliminate errors.
Next, when all is built - you ready to create image:

    #./create-bsd-image config9.sh

After this, you'll see something like *r300000-flat.vmdk* and *r300000.vmdk*.
Flat file can be *dd* to USB flash or card, and can be used to boot.
VMDK file can be used in VirtualBox (You better use it as SATA/SCSI disk, to not stick with 33 Mb speed)
 and VMWare ESXi (Which detects it just fine and use it at full SATA-300 speed).

After you add this image to your VM and ensured that at least you are booted, shut your VM down and add one more disk,
enough size to contain your data and packages. This disk will be normally seen as *da1* (*ada1*) in FreeBSD.

Next steps:

1. boot your VM, log in
2. #gpart create -s GPT /dev/da1
3. #gpart add -t freebsd-ufs -l localfs /dev/da1
4. #newfs /dev/gpt/localfs
5. #mount /dev/gpt/localfs /usr/local
6. #/root/prepare-localfs
7. #reboot

After this, you'll have system with writable /etc, /var and /usr/local to contain your data.
