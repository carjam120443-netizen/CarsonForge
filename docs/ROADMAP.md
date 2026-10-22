# CarsonForge roadmap

A milestone is complete only when its acceptance checks pass.

## Milestone 0 — Repository cleanup

- [x] Preserve CarsonForge-authored logo and branding.
- [x] Choose Gentoo/Portage as the source-built foundation.
- [x] Define the first target as an XFCE live ISO.
- [ ] Keep documentation and helper scripts aligned with the Gentoo design.

**Exit criteria:** the repository consistently describes the Gentoo target and clearly labels the old image as a preview.

## Milestone 1 — Gentoo bootstrap

- [ ] Choose and pin a Gentoo AMD64 stage3 snapshot.
- [ ] Verify stage3 integrity and record source URLs and checksums.
- [ ] Create an isolated target root and configure Portage.
- [ ] Record the selected profile, USE flags, compiler settings, and package set.
- [ ] Cache source archives and compiled packages where practical.

**Exit criteria:** the target root contains a functioning Gentoo base and Portage can install a test package.

## Milestone 2 — Bootable system and networking

- [ ] Build/select a compatible kernel and live boot setup.
- [ ] Include systemd, NetworkManager, DHCP/network dependencies, and required firmware where redistribution is permitted.
- [ ] Enable NetworkManager in the target root.
- [ ] Verify service startup, DHCP, DNS, and wired connectivity in a clean VM.
- [ ] Test Wi-Fi only where the adapter and firmware are supported.

**Exit criteria:** the live target boots and networking works in the documented VM setup.

## Milestone 3 — Porg and XFCE

- [ ] Build Porg from a pinned upstream source archive and verify it runs.
- [ ] Test Porg tracking against a disposable source-installed package.
- [ ] Build Xorg, graphics/input dependencies, D-Bus, Polkit, XFCE, and a login manager.
- [ ] Configure a live-session user and writable runtime state.
- [ ] Verify graphical login, logout, network reconnection, and reboot.

**Exit criteria:** the target boots to a usable XFCE desktop and Porg is available.

## Milestone 4 — ISO assembly and automated tests

- [ ] Assemble the target root, kernel, bootloader, and live-session configuration.
- [ ] Verify the ISO file and generate a SHA-256 checksum.
- [ ] Test the ISO in a fresh VM with no prior disk state.
- [ ] Run smoke checks for XFCE, NetworkManager, and Porg.
- [ ] Upload the ISO only after the required build and validation steps pass.
- [ ] Document any VM virtualization limits of the GitHub-hosted runner.

**Exit criteria:** the ISO passes documented artifact checks and a real VM boot test.

## Later work

- [ ] Installer and persistent installation workflow.
- [ ] Optional desktop profiles and customization.
- [ ] Release signing and a documented update strategy.

Do not describe an installer as available until installation is implemented and tested.
