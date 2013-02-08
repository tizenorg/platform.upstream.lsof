#!/bin/bash
#
# This script removes non-linux dialects from upstream source package before
# release.  There is a problem with copyrights for some UN*Xes ... also .. this
# script merges all to the one normal tarball and rename all to lsof_X.XX-linux-only.
#
# Usage:  ./upstream2downstream  <usptream-tarball>
# 
# This code is in the public domain; do with it what you wish.
#
# Copyright (C) 2007 Karel Zak <kzak@redhat.com>
#

UPSTREAM="$1"
NAME=$(basename $UPSTREAM .tar.bz2)
MYPWD=$(pwd)
TMP=$(mktemp -d)

echo
echo -n "Extracting upstream code..."
tar -jxf $UPSTREAM  -C $TMP
cd $TMP/$NAME
tar xf "$NAME"_src.tar
echo " done."

echo -n "Moving files to downstream directory..."
mv "$NAME"_src/ "$NAME"-linux-only
mv README* 00* "$NAME"-linux-only
echo " done."

echo -n "Removing non-Linux dialects..."
rm -rf "$NAME"-linux-only/dialects/{aix,darwin,du,freebsd,hpux,n+obsd,n+os,osr,sun,uw}
echo " done."

echo -n "Creating final downstream tarball..."
tar Jcf $MYPWD/"$NAME"-linux-only.tar.xz "$NAME"-linux-only
echo " done."

rm -rf $TMP
cd $MYPWD

echo
echo "Linux-only tarball: $MYPWD/"$NAME"-linux-only.tar.xz"
echo

