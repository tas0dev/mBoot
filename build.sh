#!/bin/bash
ROOT_DIR=$(cd $(dirname $0); pwd)
BR_DIR="$ROOT_DIR/buildroot"
DEFCONFIG_PATH="$ROOT_DIR/configs/mboot_defconfig"

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

mkdir -p board/mochiOS/overlay/usr/mBoot
cp ./mochiOS.img ./board/mochiOS/overlay/usr/mBoot/

cd "$BR_DIR"
make defconfig BR2_DEFCONFIG="$DEFCONFIG_PATH"
make -j8