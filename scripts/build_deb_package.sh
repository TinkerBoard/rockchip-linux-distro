#!/bin/bash

if [ -f /usr/share/crossbuild-essential-arm64/list ];then
	ARCH=arm64
elif [ -f /usr/share/crossbuild-essential-armhf/list ];then
	ARCH=armhf
fi

DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -rfakeroot -b -d -uc -us -tc -a$ARCH
#DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -rfakeroot -b -d -uc -us -a$ARCH

