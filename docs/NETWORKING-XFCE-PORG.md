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

Do not copy the GitHub Actions runner's network configuration into the target root. Hardware firmware and wireless support depend on the chosen adapter. Once NetworkManager and its matching BLFS dependencies have been built and installed in an assembled target root, run `sudo bash scripts/enable-networking.sh /path/to/target-root` from the repository. The helper refuses to proceed unless the NetworkManager systemd unit is present; it enables the service and creates a minimal keyfile-plugin configuration only when one does not already exist. It does not download or build NetworkManager.

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

Build and install Porg inside CarsonForge's LFS build/chroot environment, not on the Ubuntu Actions runner. Download the source archive from the upstream project and verify its checksum/signature when upstream provides one. Extract it, inspect its configure options, then run `sudo bash scripts/build-porg.sh /path/to/extracted-porg-source` from within the target build environment (or copy the script into that environment). The helper configures, builds, installs, and creates `/var/lib/porg`; because Porg cannot track its own first installation, test logging on a disposable package before using it for system components. This helper has not yet been run against the target's chosen compiler/libc.

Example usage after Porg is built and configured in the target:
```sh
porg -lD -- make install
porg -a
porg -f example-package
```

The exact options and behavior should be checked against the installed Porg manual. Do not run package-removal commands against a live system until the package's file list has been reviewed.

## Suggested order

1. Finish and test the LFS base and kernel.
2. Build/install NetworkManager and its matching BLFS dependencies, then run `scripts/enable-networking.sh` against the assembled target root and verify wired networking.
3. Add firmware and test Wi-Fi where applicable.
4. Build Porg with `scripts/build-porg.sh` and validate its install log on a disposable test package.
5. Build the Xorg/graphics stack and XFCE using the matching BLFS book.
6. Produce a new ISO from the assembled target root and test it in a clean VM.

References: [LFS systemd book](https://www.linuxfromscratch.org/lfs/view/stable-systemd/), [Beyond Linux From Scratch](https://www.linuxfromscratch.org/blfs/), [Porg project](https://porg.sourceforge.net/), [Porg source files](https://sourceforge.net/projects/porg/files/).
