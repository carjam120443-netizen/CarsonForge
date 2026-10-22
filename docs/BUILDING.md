# Building CarsonForge

## Status

CarsonForge is in early development. The repository does not yet provide a complete,
reproducible end-to-end LFS toolchain build. This guide covers the starter rootfs
configuration and packaging already provided.

## Base root filesystem

The `rootfs/` directory contains configuration seeds, not a complete operating system.
Follow the official [Linux From Scratch systemd book](https://www.linuxfromscratch.org/lfs/view/systemd/)
and the project roadmap to build the toolchain and target userland. Assemble those outputs
into a dedicated target root and layer in the appropriate files from `rootfs/`.
Never copy these files over a live host's root filesystem.

## Package a base ISO

On an x86_64 Linux build host, install `grub-mkrescue` and `xorriso` using your host
distribution's package manager. Prepare these inputs:

- `build/boot/vmlinuz` — kernel compiled for CarsonForge
- `build/boot/initramfs.img` — initramfs with a working `/init` and the userspace
  needed to start the system
- `build/rootfs/etc/os-release` — CarsonForge metadata from `rootfs/etc/os-release`
  copied into the assembled target root

Then run:

```bash
chmod +x scripts/build-base-iso.sh
scripts/build-base-iso.sh
```

The ISO is written to `out/carsonforge-base-x86_64.iso`. Customize paths with
`KERNEL_PATH`, `INITRAMFS_PATH`, `ROOTFS_DIR`, `OUTPUT_DIR`, or `ISO_PATH`.

**Important:** the script packages existing artifacts; it does not compile the kernel,
create the initramfs, or build the LFS userland. GRUB displaying a menu does not prove
the live system works. The initramfs must contain a valid `/init` and everything needed
to start the intended userspace. Test the ISO in a disposable VM before attempting
hardware installation.

## Current stages

1. Run `scripts/check-host.sh` and review its requirements.
2. Build the LFS cross-toolchain and target userland according to the LFS systemd book.
3. Assemble the target root and apply the configuration seeds from `rootfs/`.
4. Build and test a compatible kernel and initramfs for the chosen boot model.
5. Package and test the ISO with `scripts/build-base-iso.sh`.
