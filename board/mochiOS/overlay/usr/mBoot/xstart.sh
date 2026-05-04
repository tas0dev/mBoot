#!/bin/sh

echo "[mBoot] setting env..."
OVMF="/usr/mBoot/OVMF.fd"
TARGET_IMG="/usr/mBoot/mochiOS.img"
ESP_IMG="/usr/mBoot/esp.img"
echo "[mBoot] setted"

echo "[mBoot] enabling kvm..."
KVM_ARGS=""
if [ -e /dev/kvm ]; then
    ACCEL_ARGS="-enable-kvm -cpu host"
    echo "[mBoot] enabled kvm"
else
    ACCEL_ARGS="-accel tcg,thread=single -cpu max"
    echo "[mBoot] Your processor does not have KVM support."
fi

echo "[mBoot] Booting mochiOS..."
exec qemu-system-x86_64 \
    $ACCEL_ARGS \
    -bios "$OVMF" \
    -drive format=raw,file="$ESP_IMG",index=0,media=disk \
    -drive format=raw,file="$TARGET_IMG",index=1,media=disk \
    -usb \
    -device qemu-xhci,id=xhci \
    -device usb-kbd,bus=xhci.0 \
    -device usb-tablet,bus=xhci.0 \
    -net none \
    -m 512M \
    -serial stdio \
    -vga std \
    -display sdl,show-cursor=off
    -full-screen