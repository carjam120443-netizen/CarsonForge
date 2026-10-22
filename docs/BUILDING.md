# Building CarsonForge

## Status

CarsonForge is transitioning from a minimal BusyBox developer preview to a Gentoo-based live desktop. A complete Gentoo bootstrap, XFCE image, and automated boot test are not implemented yet.

## Build strategy

Use a pinned Gentoo `amd64` stage3 as the bootstrap environment. Build the target system in an isolated root with Portage, recording the selected profile, USE flags, package set, and source inputs. Most packages should be built from source through Portage.

The initial target package set should stay small and include:

- a systemd-based Gentoo base system;
- kernel and boot support suitable for the live ISO;
- NetworkManager and required DHCP/network dependencies;
- the Xorg and graphics/input stack needed by the test environment;
- XFCE and a display/login manager;
- Porg, built from upstream source;
- CarsonForge identity and branding.

Use Gentoo's official [AMD64 Handbook](https://wiki.gentoo.org/wiki/Handbook:AMD64) and [Portage documentation](https://wiki.gentoo.org/wiki/Portage) for bootstrap and package-management details. Pin and record the chosen stage3 rather than silently following a moving input.

## Main build stages

1. Download and verify the chosen Gentoo stage3.
2. Prepare an isolated build root and configure Portage for the target.
3. Build the minimal system and boot dependencies.
4. Build and configure NetworkManager, then verify the service and network tools exist in the target.
5. Build Porg from source and test it on a disposable package.
6. Build the graphics stack and XFCE session.
7. Assemble the live root, bootloader, kernel, and writable runtime state into an ISO.
8. Generate an ISO checksum and run artifact checks.
9. Boot the image in a clean virtual machine and verify XFCE login, networking, Porg, and reboot behavior.

## GitHub Actions

Keep one main workflow responsible for bootstrap, package builds, ISO creation, smoke tests, and artifact upload. Cache Portage distfiles and compiled package artifacts to reduce repeated work. The hosted runner's time, disk, and virtualization limits must be measured; if a complete source build exceeds them, document the limitation rather than publishing the old BusyBox image as if it were the Gentoo release.

Repository checks should remain quick and should not download or build the entire operating system.

## Legacy BusyBox preview

The existing `scripts/build-base-iso.sh` and current ISO workflow package a minimal BusyBox initramfs using the runner's kernel. They are temporary preview tooling. They do not bootstrap Gentoo, compile the target kernel or userland, or provide a live desktop. Keep the preview clearly labeled until the Gentoo pipeline has passed its acceptance checks.

## Safety and validation

Build in an isolated environment; never point destructive build commands at the host root filesystem. Test in a disposable VM before testing on physical hardware. Do not claim the image is usable merely because an ISO file exists or a bootloader menu appears.
