#!/bin/sh

cd $sourcedir

if [ ! -d "$version" ]; then
    mkdir $version ; svn co http://svn.freebsd.org/base/stable/$version/ $version
else
    cd $version; svn up
fi
