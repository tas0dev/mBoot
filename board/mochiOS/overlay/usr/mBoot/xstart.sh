#!/bin/sh

echo "[mBoot] setting env..."
OVMF="/usr/mBoot/OVMF.fd"
TARGET_IMG="/usr/mBoot/mochiOS.img"
echo "[mBoot] setted"

echo "[mBoot] enabling kvm..."
KVM_ARGS=""
if [ -e /dev/kvm ]; then
    KVM_ARGS="-enable-kvm -cpu host"
    echo "[mBoot] enabled kvm"
else
    echo "[mBoot] Your processor does not have KVM support."
fi

echo "[mBoot] Booting mochiOS..."
exec qemu-system-x86_64 \
    $KVM_ARGS \
    -bios "$OVMF" \
    -drive format=raw,file="$TARGET_IMG",media=disk \
    -usb \
    -device qemu-xhci,id=xhci \
    -device usb-kbd,bus=xhci.0 \
    -device usb-tablet,bus=xhci.0 \
    -net none \
    -m 512M \
    -serial stdio \
    -vga std \
    -display sdl \
    -full-screen