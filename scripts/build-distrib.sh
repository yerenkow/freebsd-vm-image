#!/bin/sh

cd $sourcedir/$version

nice make -j 4 buildworld TARGET=$arch

nice make -j 4 buildkernel TARGET=$arch

