#!/bin/sh

dmesg > dmesg-`date +"%Y%m%d-%H%M"`.log
pciconf -lvb > pciconf-`date +"%Y%m%d-%H%M"`.log
cp xorg.conf xorg.conf-`date +"%Y%m%d-%H%M"`.log

X -wr -verbose 100 -logverbose 100 -config xorg.conf > output-from-x.log 2> error-from-x.log &
sleep 5
env DISPLAY=:0 xterm &
sleep 10
env DISPLAY=:0 /usr/local/bin/openbox &
env DISPLAY=:0 xterm &

