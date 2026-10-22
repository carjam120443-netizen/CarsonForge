# Building CarsonForge

## Status

CarsonForge now has an initial experimental Gentoo stage3 → Portage → XFCE ISO pipeline in `scripts/build-gentoo-iso.sh` and `.github/workflows/build-gentoo-iso.yml`. It has been committed but has not yet been confirmed by a successful Actions run or VM boot. Expect to iterate on package availability, live-initramfs configuration, runner disk usage, and build duration.

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

Run **Build CarsonForge Gentoo XFCE ISO (experimental)** from the Actions tab to attempt the full bootstrap and ISO assembly. It downloads the current systemd amd64 stage3, checks its SHA-512 digest against Gentoo's DIGESTS file, configures the isolated target root, asks Portage to install the package set in `packages/gentoo-packages.txt`, and attempts to create a squashfs live ISO. The workflow uploads the ISO and SHA-256 file only if all steps complete.

This is an initial end-to-end attempt, not a validated release pipeline. Review the actual workflow logs after the first run. Hosted-runner disk and time limits may be insufficient for a large source build; the current configuration prefers Gentoo binary packages when available, so it does not guarantee every package is compiled from source. Repository checks stay fast and only syntax-check the scripts.

## Legacy BusyBox preview

The existing `scripts/build-base-iso.sh` and current ISO workflow package a minimal BusyBox initramfs using the runner's kernel. They are temporary preview tooling. They do not bootstrap Gentoo, compile the target kernel or userland, or provide a live desktop. Keep the preview clearly labeled until the Gentoo pipeline has passed its acceptance checks.

## Safety and validation

Build in an isolated environment; never point destructive build commands at the host root filesystem. Test in a disposable VM before testing on physical hardware. Do not claim the image is usable merely because an ISO file exists or a bootloader menu appears.
