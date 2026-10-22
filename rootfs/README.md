# CarsonForge root filesystem overlay

This directory contains small CarsonForge-owned configuration seeds for the target root. It is not a complete Linux userspace and must never be copied over a live host's `/`.

Current files:

- `etc/os-release` — OS identity and project metadata
- `etc/hostname` — default hostname
- `etc/issue` and `etc/motd` — console/login text
- `etc/fstab.example` — example mount table; intentionally not an active `fstab`

## Target system

The planned root filesystem is based on Gentoo stage3 and populated through Portage. The live ISO will also need a compatible kernel, bootloader, complete userspace, XFCE session, NetworkManager, Porg, and writable runtime state.

The current ISO workflow still creates a minimal BusyBox preview; it does not assemble this overlay into a complete Gentoo system. See [the build guide](../docs/BUILDING.md) for the transition plan.
