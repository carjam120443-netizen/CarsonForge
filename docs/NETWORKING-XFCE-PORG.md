# Networking, XFCE, and Porg

CarsonForge is still at the bootable BusyBox-preview stage. These are target-system integration plans, not claims that the current ISO already contains networking or a desktop.

## Networking (LFS/BLFS target)

Use the official LFS systemd book for base network configuration, then follow the matching BLFS edition for additional software. For the first desktop-capable target, prefer **NetworkManager** for wired, Wi-Fi, DHCP, and connection profiles. Include its runtime dependencies and a suitable Wi-Fi backend, and enable its systemd service in the target root.

Acceptance checks:
- [ ] The target kernel has the required Ethernet/Wi-Fi driver and firmware for the test VM/device.
- [ ] NetworkManager starts under systemd.
- [ ] A wired connection obtains an address through DHCP.
- [ ] Wi-Fi can scan and connect when a supported adapter and firmware are available.
- [ ] DNS resolution and outbound connectivity work after reboot.
- [ ] Networking is tested in a clean VM; host networking is not mistaken for target networking.

Do not copy the GitHub Actions runner's network configuration into the target root. Hardware firmware and wireless support depend on the chosen adapter.

## XFCE desktop (BLFS target)

Build XFCE only after the LFS base boots reliably and the target has a working network stack. Follow the **same pinned BLFS edition** for Xorg, graphics drivers, D-Bus, Polkit, desktop libraries, XFCE components, and a display/login manager. Keep the desktop optional until a minimal boot and recovery console are reliable.

Initial profile goals:
- [ ] Xorg display server and required graphics/input drivers
- [ ] D-Bus and Polkit services
- [ ] XFCE core, session, settings, panel, desktop, and window manager
- [ ] A display manager or a documented startx/session path
- [ ] NetworkManager integration (including a panel applet if desired)
- [ ] A normal unprivileged user can log into XFCE
- [ ] A clean VM test verifies login, logout, reboot, and network reconnection

XFCE is not a package that can simply be copied into the current BusyBox initramfs; it needs a built userspace, libraries, graphics stack, and a persistent/live root filesystem.

## Porg source-install tracking

[Porg](https://porg.sourceforge.net/) records files installed by source builds and can help inventory/uninstall those packages. The upstream SourceForge listing currently offers **porg 0.10**; it is an older release, so test it against CarsonForge's selected compiler and libc before relying on it.

Build and install Porg into the **target root**, not the build host. Use the source archive from the upstream project, verify it with a trusted checksum/signature if available, inspect its configure options, then build it in the LFS/BLFS environment. Initialize and protect its package log directory (normally `/var/lib/porg`) and test logging on a disposable package before using it for system components.

Example usage after Porg is built and configured in the target:
```sh
porg -lD -- make install
porg -a
porg -f example-package
```

The exact options and behavior should be checked against the installed Porg manual. Do not run package-removal commands against a live system until the package's file list has been reviewed.

## Suggested order

1. Finish and test the LFS base and kernel.
2. Add NetworkManager and verify wired networking.
3. Add firmware and test Wi-Fi where applicable.
4. Build Porg and validate its install log on a disposable test package.
5. Build the Xorg/graphics stack and XFCE using the matching BLFS book.
6. Produce a new ISO from the assembled target root and test it in a clean VM.

References: [LFS systemd book](https://www.linuxfromscratch.org/lfs/view/stable-systemd/), [Beyond Linux From Scratch](https://www.linuxfromscratch.org/blfs/), [Porg project](https://porg.sourceforge.net/), [Porg source files](https://sourceforge.net/projects/porg/files/).
