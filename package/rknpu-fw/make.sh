#!/bin/bash

set -e

source $OUTPUT_DIR/.config

cd $TOP_DIR/external/rknpu-fw

if [ x$BR2_PACKAGE_RKNPU_PCIE = xy ];then
    mkdir -p $TARGET_DIR/usr/share/npu_fw
    install -m 0755 -D  $TOP_DIR/external/rknpu-fw/npu_fw_pcie/* $TARGET_DIR/usr/share/npu_fw/
    install -m 0755 -D  $TOP_DIR/external/rknpu-fw/bin/npu-image.sh $TARGET_DIR/usr/bin/
    install -m 0755 -D  $TOP_DIR/external/rknpu-fw/bin/npu_transfer_proxy $TARGET_DIR/usr/bin/
    install -m 0755 -D  $TOP_DIR/external/rknpu-fw/bin/npu_upgrade_pcie $TARGET_DIR/usr/bin/npu_upgrade
    install -m 0755 -D  $TOP_DIR/external/rknpu-fw/bin/upgrade_tool $TARGET_DIR/usr/bin/
    install -m 0755 -D  $TOP_DIR/external/rknpu-fw/bin/npu_powerctrl_combine $TARGET_DIR/usr/bin/
    install -m 0755 -D  $TOP_DIR/external/rknpu-fw/S11_npu_init $TARGET_DIR/etc/init.d/
else
    mkdir -p $TARGET_DIR/usr/share/npu_fw
    install -m 0755 -D  $TOP_DIR/external/rknpu-fw/npu_fw/* $TARGET_DIR/usr/share/npu_fw/
    install -m 0755 -D  $TOP_DIR/external/rknpu-fw/bin/npu-image.sh $TARGET_DIR/usr/bin/
    install -m 0755 -D  $TOP_DIR/external/rknpu-fw/bin/npu_transfer_proxy $TARGET_DIR/usr/bin/
    install -m 0755 -D  $TOP_DIR/external/rknpu-fw/bin/npu_upgrade $TARGET_DIR/usr/bin/
    install -m 0755 -D  $TOP_DIR/external/rknpu-fw/bin/upgrade_tool $TARGET_DIR/usr/bin/
    install -m 0755 -D  $TOP_DIR/external/rknpu-fw/bin/npu_powerctrl $TARGET_DIR/usr/bin/
    install -m 0755 -D  $TOP_DIR/external/rknpu-fw/S11_npu_init $TARGET_DIR/etc/init.d/
fi
