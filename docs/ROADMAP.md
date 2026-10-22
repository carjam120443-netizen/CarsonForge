# CarsonForge roadmap

A stage is complete only when its acceptance checks pass.

## Milestone 0 — Repository foundation

- [x] Project identity and initial documentation.
- [x] CLI-first first release defined.
- [x] Non-destructive host inventory script.
- [ ] Add CI checks for shell scripts and Markdown.
- [ ] Record the exact LFS edition used for the first build.

**Exit criteria:** repository conventions and build plan are documented.

## Milestone 1 — Isolated build environment

- [ ] Choose a supported Linux host compatible with the selected LFS edition.
- [ ] Create a dedicated build VM with adequate disk, memory, and CPU.
- [ ] Create a separate target virtual disk and document its verified mount mapping.
- [ ] Run the LFS host-requirements checks and save output.
- [ ] Download the exact package versions listed in the chosen book and verify available checksums/signatures.
- [ ] Keep source archives and logs outside the target root filesystem.

**Exit criteria:** host checks pass, the target disk is positively identified, and source archives match the book.

## Milestone 2 — Toolchain and temporary tools

- [ ] Prepare the LFS filesystem and restricted build user.
- [ ] Build the cross-toolchain.
- [ ] Build temporary tools in book order.
- [ ] Enter chroot only when the book's prerequisites are satisfied.
- [ ] Preserve logs and record the last completed package.

**Exit criteria:** temporary environment is complete and required checks pass.

## Milestone 3 — Base system

- [ ] Build the packages in the selected LFS system chapters.
- [ ] Configure networking, locale, console, and systemd according to the book.
- [ ] Record package versions and all deviations.
- [ ] Run applicable upstream test suites.

**Exit criteria:** base system is complete without undocumented deviations.

## Milestone 4 — First VM boot

- [ ] Configure /etc/fstab for the target VM's actual filesystem layout.
- [ ] Build and configure a suitable kernel.
- [ ] Install and configure GRUB using the book's procedure.
- [ ] Boot the installed target disk in a clean VM.
- [ ] Verify systemd reaches a usable text console.
- [ ] Create and test a normal user account.

**Exit criteria:** repeatable boot to a CLI login in a clean VM.

## Milestone 5 — Bootable ISO

- [ ] Define BIOS and/or UEFI support.
- [ ] Choose and document the ISO filesystem and bootloader layout.
- [ ] Package a known-good root filesystem without modifying the source build.
- [ ] Generate a checksum for the ISO.
- [ ] Test in a fresh VM with no existing disk state.
- [ ] Explicitly decide whether the first image is live, installer-based, or an installable system image.

**Exit criteria:** documented ISO boots in a clean VM and its checksum verifies. Do not call it an installer unless installation is implemented and tested.

## Milestone 6 — CarsonForge identity

- [ ] Add CarsonForge os-release, hostname, MOTD, and release metadata.
- [ ] Document which files are generated during a build.
- [ ] Add project branding with appropriate asset licenses.
- [ ] Define release versioning.

**Exit criteria:** the running base identifies itself as CarsonForge and can be rebuilt from documented inputs.

## Later

Potential future work includes package management, automated updates, optional desktop profiles, and an installer. These remain deferred until the CLI base and ISO are reliable.
