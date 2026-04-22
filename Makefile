BUILDROOT_DIR = $(shell pwd)/buildroot
CONFIG_NAME = mboot_defconfig
CONFIG_FILE = $(shell pwd)/configs/$(CONFIG_NAME)
OUTPUT_DIR = $(BUILDROOT_DIR)/output
IMAGES_DIR = $(OUTPUT_DIR)/images
IMAGES  := $(BUILDROOT_DIR)/output/images
LINUX_CONFIG_FILE := $(shell pwd)/configs/linux_defconfig

.PHONY: all setup build clean qemu save-config

all: setup build

setup:
	@echo "Setting up Buildroot with $(CONFIG_NAME)..."
	$(MAKE) -C $(BUILDROOT_DIR) BR2_EXTERNAL=$(shell pwd) $(CONFIG_NAME)

build:
	@echo "Starting Buildroot build..."
	$(MAKE) -C $(BUILDROOT_DIR)

save-config:
	@echo "Saving Buildroot configuration..."
	@$(MAKE) -C $(BUILDROOT_DIR) savedefconfig BR2_DEFCONFIG=$(CONFIG_FILE)
	@echo "Saving Linux kernel configuration..."
	@$(MAKE) -C $(BUILDROOT_DIR) linux-savedefconfig
	@cp $(BUILDROOT_DIR)/output/build/linux-*/defconfig $(LINUX_CONFIG_FILE)
	@ls ./configs

run:
	@qemu-system-x86_64 \
			-kernel $(IMAGES)/bzImage \
			-drive file=$(IMAGES)/rootfs.ext2,format=raw \
			-append "root=/dev/sda console=tty1 console=ttyS0" \
			-serial stdio \
			-vga std \
			-display sdl \
			-m 1G

clean:
	$(MAKE) -C $(BUILDROOT_DIR) clean

help:
	@echo "Usage:"
	@echo "  make             - Build everything (Not recommended)"
	@echo "  make setup       - Setup buildroot"
	@echo "  make save-config - Save .config to configs/$(DEFCONFIG)"
	@echo "  make run         - Boot the image with QEMU"
	@echo " ./build.sh        - Build (recommended)"