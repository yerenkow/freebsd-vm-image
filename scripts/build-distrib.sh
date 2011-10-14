#!/bin/sh

cd $sourcedir/$version

nice make -j 4 buildworld

nice make -j 4 buildkernel

