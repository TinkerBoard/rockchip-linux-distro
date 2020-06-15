#!/bin/bash

set -e
DEPENDENCIES=libdrm
$SCRIPTS_DIR/build_pkgs.sh $ARCH $SUITE "$DEPENDENCIES"
PKG=linux-rga
mkdir -p $BUILD_DIR/$PKG
cp -r $TOP_DIR/external/$PKG $BUILD_DIR/$PKG
cd $BUILD_DIR/$PKG
CFLAGS="$CFLAGS -I$TARGET_DIR/usr/include/libdrm -DLIBDRM=1"
CXXFLAGS=$CFLAGS
LDFLAGS="$LDFLAGS"
PROJECT_DIR="$BUILD_DIR/$PKG" make -C $TOP_DIR/external/$PKG -j$RK_JOBS
install -D -m 644 $BUILD_DIR/$PKG/lib/librga.so $TARGET_DIR/usr/lib/
cd -
