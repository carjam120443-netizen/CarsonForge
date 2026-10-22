# CarsonForge base root filesystem

This directory contains project-owned configuration seeds to install into a dedicated
CarsonForge target root during the Linux From Scratch build. It is not a complete Linux
userspace and must never be copied over a live host's `/`.

Current files:
- `etc/os-release` — OS identity and project metadata
- `etc/hostname` — default hostname
- `etc/issue` and `etc/motd` — console/login text
- `etc/fstab.example` — example mount table; intentionally not an active `fstab`

## What is still needed for a working ISO?

A compatible kernel and an initramfs containing a working `/init`, required programs,
libraries, and the boot model's root-filesystem setup. The ISO packaging script only
packages those existing artifacts; it does not compile the kernel or build LFS packages.

Expected build inputs:
- `build/rootfs/etc/os-release`
- `build/boot/vmlinuz`
- `build/boot/initramfs.img`

See [the build guide](../docs/BUILDING.md).
