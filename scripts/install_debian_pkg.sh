#!/bin/bash

ARCH=$1
SUITE=$2
PACKAGES="$3"
AUTH=$4
export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true LC_ALL=C LANGUAGE=C LANG=C
export PATH=$PATH:/usr/sbin:/sbin
export PROOT_NO_SECCOMP=1

CHROOTQEMUCMD="proot -q qemu-$QEMU_ARCH-static -v -1 -0 -b /dev -b /sys -b /proc -r"
CHROOTCMD="proot -v -1 -0 -r"
if [ ! -e $OUTPUT_DIR/.mirror ];then
	export MIRROR=`$SCRIPTS_DIR/get_mirror.sh $SUITE $ARCH default`
	echo $MIRROR > $OUTPUT_DIR/.mirror
else
	export MIRROR=`cat $OUTPUT_DIR/.mirror`
fi

echo "[General]" > $OUTPUT_DIR/multistrap.conf
echo "arch=$DEB_SOURCE_ARCH" >> $OUTPUT_DIR/multistrap.conf
echo "directory=$TARGET_DIR" >> $OUTPUT_DIR/multistrap.conf
echo "cleanup=true" >> $OUTPUT_DIR/multistrap.conf
echo "unpack=true" >> $OUTPUT_DIR/multistrap.conf
echo "bootstrap=Debian" >> $OUTPUT_DIR/multistrap.conf
echo "aptsources=Debian" >> $OUTPUT_DIR/multistrap.conf
echo "allowrecommends=false" >> $OUTPUT_DIR/multistrap.conf
echo "addimportant=false" >> $OUTPUT_DIR/multistrap.conf
echo "" >> $OUTPUT_DIR/multistrap.conf
echo "[Debian]" >> $OUTPUT_DIR/multistrap.conf
echo "packages=$PACKAGES" >> $OUTPUT_DIR/multistrap.conf
echo "source=$MIRROR" >> $OUTPUT_DIR/multistrap.conf
echo "keyring=debian-archive-keyring" >> $OUTPUT_DIR/multistrap.conf
echo "suite=$SUITE" >> $OUTPUT_DIR/multistrap.conf
echo "omitdebsrc=true" >> $OUTPUT_DIR/multistrap.conf
[ x$AUTH != "xinit" ] && `echo "noauth=true" >> $OUTPUT_DIR/multistrap.conf` || true
echo "" >> $OUTPUT_DIR/multistrap.conf

echo "download and install "$PACKAGES". it will take a while. log will be saved in $OUTPUT_DIR/log"

# Prepare keyrings
KEYRING_DIR=$DISTRO_DIR/keyring/debian-archive-keyring/usr/share/keyrings
KEYRINGS=$(find $KEYRING_DIR -name "*.gpg"|grep -v removed)
[ -n "$KEYRINGS" ] && \
	mkdir -p $TARGET_DIR/etc/apt/trusted.gpg.d/ &&
	ln -sf apt/trusted.gpg.d $TARGET_DIR/etc/trusted.gpg.d &&
	install -m 644 $KEYRINGS $TARGET_DIR/etc/apt/trusted.gpg.d/

proot -0 multistrap -f $OUTPUT_DIR/multistrap.conf >> $OUTPUT_DIR/log
if [ $? -ne 0 ]; then
	echo "Failed!!!"
	tail -n 100 $OUTPUT_DIR/log
	exit 1
else
	echo "done!"
fi
for script in $TARGET_DIR/var/lib/dpkg/info/*.preinst; do
DPKG_MAINTSCRIPT_NAME=preinst DPKG_MAINTSCRIPT_PACKAGE="`basename $script .preinst`" $CHROOTQEMUCMD $TARGET_DIR ${script##$TARGET_DIR} install >> $OUTPUT_DIR/log
if [ $? -ne 0 ]; then
        echo "post install failed!!!"
        tail -n 100 $OUTPUT_DIR/log
        exit 1
fi
done
$CHROOTQEMUCMD $TARGET_DIR /usr/bin/dpkg --configure -a >> $OUTPUT_DIR/log
if [ $? -ne 0 ]; then
        echo "dpkg configure failed!!!"
        tail -n 100 $OUTPUT_DIR/log
        exit 1
fi
$SCRIPTS_DIR/fix_link.sh $TARGET_DIR/usr/lib/$TOOLCHAIN >> $OUTPUT_DIR/log

