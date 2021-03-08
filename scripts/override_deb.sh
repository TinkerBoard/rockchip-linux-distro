#!/bin/bash

QEMU=qemu-$QEMU_ARCH-static
CHROOTQEMUCMD="proot -q $QEMU -v -1 -0 -b /dev -b /sys -b /proc -b $OVERRIDE_PKG_DIR/$ARCH/:/tmp/ -r"

[ ! -d $BUILD_DIR/override ] && mkdir -p $BUILD_DIR/override
[ ! -f $BUILD_DIR/override/.override ] && touch $BUILD_DIR/override/.override

for pkg_name in `ls $OVERRIDE_PKG_DIR/$ARCH/`
do
	[ ! -z `grep -Fx $pkg_name $BUILD_DIR/override/.override` ] && continue
	echo "I: override package:"$pkg_name;
	$CHROOTQEMUCMD $TARGET_DIR /usr/bin/dpkg -i /tmp/$pkg_name;
	echo $pkg_name >> $BUILD_DIR/override/.override
done