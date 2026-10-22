#!/usr/bin/env bash
# Package a previously built CarsonForge kernel + initramfs into a GRUB-bootable ISO.
# This script packages boot artifacts; it does not compile the Linux kernel or LFS userspace.
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${BUILD_DIR:-$ROOT_DIR/build}"
BOOT_DIR="${BOOT_DIR:-$BUILD_DIR/boot}"
ROOTFS_DIR="${ROOTFS_DIR:-$BUILD_DIR/rootfs}"
OUTPUT_DIR="${OUTPUT_DIR:-$ROOT_DIR/out}"
ISO_PATH="${ISO_PATH:-$OUTPUT_DIR/carsonforge-base-x86_64.iso}"
KERNEL_PATH="${KERNEL_PATH:-$BOOT_DIR/vmlinuz}"
INITRAMFS_PATH="${INITRAMFS_PATH:-$BOOT_DIR/initramfs.img}"
GRUB_CFG="$ROOT_DIR/config/grub.cfg"

die() { printf 'error: %s\n' "$*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || die "Required host tool '$1' was not found."; }

[[ "$(uname -m)" == "x86_64" ]] || die "Build this x86_64 ISO on an x86_64 Linux host."
need grub-mkrescue
need xorriso
need install
need cp
need mkdir
need find

[[ -f "$KERNEL_PATH" ]] || die "Kernel not found: $KERNEL_PATH (build/install it as build/boot/vmlinuz first)."
[[ -f "$INITRAMFS_PATH" ]] || die "Initramfs not found: $INITRAMFS_PATH (build one containing the CarsonForge base userspace first)."
[[ -d "$ROOTFS_DIR" ]] || die "Root filesystem staging directory not found: $ROOTFS_DIR"
[[ -f "$GRUB_CFG" ]] || die "GRUB configuration not found: $GRUB_CFG"
[[ -f "$ROOTFS_DIR/etc/os-release" ]] || die "Missing $ROOTFS_DIR/etc/os-release; populate the CarsonForge base root filesystem first."

STAGE="$BUILD_DIR/iso-root"
rm -rf -- "$STAGE"
mkdir -p "$STAGE/boot/grub" "$OUTPUT_DIR"
install -m 0644 "$KERNEL_PATH" "$STAGE/boot/vmlinuz"
install -m 0644 "$INITRAMFS_PATH" "$STAGE/boot/initramfs.img"
install -m 0644 "$GRUB_CFG" "$STAGE/boot/grub/grub.cfg"

# Include a copy of the baseline configuration for inspection/recovery. The running
# live system is supplied by the initramfs; this directory alone is not a live root.
mkdir -p "$STAGE/metadata"
cp "$ROOTFS_DIR/etc/os-release" "$STAGE/metadata/os-release"
printf 'CarsonForge base ISO\n' > "$STAGE/metadata/README.txt"

printf 'Packaging CarsonForge base ISO...\n'
grub-mkrescue -o "$ISO_PATH" "$STAGE"
printf '\nCreated: %s\n' "$ISO_PATH"
printf 'Note: test the ISO in a VM. A bootable initramfs with a working /init is required.\n'
