#!/bin/bash -x

SCRIPT_DIR=$(dirname $(realpath "$0"))
SDK_DIR=$(realpath "$SCRIPT_DIR/../..")
ARCH=$1

if [ ! -n "$ARCH" ];then
        echo "set arch to arm64 as default"
        ARCH=64
fi

if [ $ARCH = 32 ];then
	DOCKFILE=dockerfile32
elif [ $ARCH = 64 ];then
	DOCKFILE=dockerfile64
else
	echo "wrong arch!!"
	exit 1
fi

docker pull hub.c.163.com/library/debian:buster
docker build --force-rm -t rkdebian:buster - < $SCRIPT_DIR/$DOCKFILE
docker run -it -v $SDK_DIR:/home/rk/sdk rkdebian:buster /bin/bash
