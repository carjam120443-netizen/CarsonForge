# Networking, XFCE, and Porg

This document describes the target Gentoo-based CarsonForge live system. The current BusyBox preview does not yet include these components.

## Networking

Use Gentoo's Portage system to install NetworkManager and its dependencies into the target root. Enable the NetworkManager service in the target system and include DHCP support, command-line tools for diagnostics, and suitable firmware where redistribution is permitted.

Acceptance checks:

- [ ] NetworkManager and its service unit are present in the target root.
- [ ] NetworkManager starts in the live session.
- [ ] Wired networking obtains an address through DHCP.
- [ ] DNS resolution and outbound connectivity work after reboot.
- [ ] Wi-Fi can scan and connect when a supported adapter and firmware are available.
- [ ] Tests run in a clean VM; runner networking is not mistaken for target networking.

Hardware support depends on the selected kernel, adapter, and firmware. Do not copy the GitHub runner's network configuration into the target.

## XFCE live desktop

Build the desktop after the base system and networking are reliable. Use Portage to build the required Xorg/graphics/input stack, D-Bus, Polkit, XFCE components, and a display/login manager.

Initial desktop goals:

- [ ] XFCE session, panel, settings, desktop, and window manager are installed.
- [ ] A supported graphics mode starts in the target VM.
- [ ] The live session has a dedicated unprivileged user.
- [ ] Runtime writes go to a documented writable overlay or temporary filesystem.
- [ ] NetworkManager integration is available from the desktop.
- [ ] Login, logout, reboot, and recovery to a console are tested.

XFCE cannot be added by copying a few files into the existing BusyBox initramfs. It requires a complete userspace, libraries, graphics stack, and a working live-root design.

## Porg

[Porg](https://porg.sourceforge.net/) tracks files installed by source builds and can help inventory source-installed software. Build it from a pinned upstream source archive inside the Gentoo target build environment, not on the Ubuntu runner as a substitute for the target build.

- [ ] Record the exact upstream source version and checksum.
- [ ] Inspect the configure options and build logs.
- [ ] Install Porg into the target root.
- [ ] Verify the executable starts in the target environment.
- [ ] Test tracking on a disposable source-installed package before relying on it for system components.

Portage remains the system package manager. Porg is an additional tool for tracking software installed outside Portage; it should not replace Portage's package database or manage Portage-owned files.

## Build order

1. Bootstrap and verify the Gentoo target root.
2. Build the kernel and live boot infrastructure.
3. Build and enable NetworkManager, then test wired networking.
4. Build Porg and verify its behavior on a disposable test package.
5. Build the graphics stack, XFCE, and login manager.
6. Assemble the live ISO and test the full boot and desktop flow.

## References

- [Gentoo AMD64 Handbook](https://wiki.gentoo.org/wiki/Handbook:AMD64)
- [Portage](https://wiki.gentoo.org/wiki/Portage)
- [Gentoo NetworkManager documentation](https://wiki.gentoo.org/wiki/NetworkManager)
- [Porg project](https://porg.sourceforge.net/)
