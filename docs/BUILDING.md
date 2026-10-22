# Building CarsonForge

## Status

This document describes the intended workflow. The repository does not yet contain a complete LFS build engine or ISO generator. The official book is the authority for package commands.

## 1. Select and pin the book

Use the [official stable systemd LFS book](https://www.linuxfromscratch.org/lfs/view/stable-systemd/index.html). Before each build series:

1. Record the book version and publication date.
2. Check the [official errata](https://www.linuxfromscratch.org/lfs/errata/stable-systemd/).
3. Use package versions and patches listed for that exact edition.
4. Do not mix instructions from different editions silently.

## 2. Isolated Linux VM

Build inside a dedicated Linux VM, not directly on the Windows host or the host root filesystem. Use a separate target virtual disk for the LFS filesystem and take VM snapshots before major stages.

Before formatting or mounting anything, identify the target disk and confirm its size, filesystem, and mount point. Never assume an example device name identifies the correct disk.

## 3. Host requirements

The selected LFS book's host requirements are authoritative. Check compiler, linker, shell, and required utility versions using the book's own procedure. The repository script scripts/check-host.sh is only an initial inventory; a successful result does not prove LFS requirements are satisfied.

## 4. Sources and logs

Keep source downloads, build logs, and temporary build data outside the target root filesystem. Record the LFS edition, host distribution and tool versions, archive names and checksums, build timestamps and exit status, deviations, and the last completed chapter/package.

Read each book section before executing it. Do not run unreviewed commands as root.

## 5. Follow the book in order

Broadly, LFS proceeds through host preparation, source preparation, cross-toolchain, temporary tools, chroot, base packages, system configuration, kernel, filesystem table, and GRUB. Use the exact chapter order and commands from the selected edition.

Future scripts should automate narrow, well-understood stages. Each should fail on errors, log output, validate inputs, and avoid destructive actions unless a carefully validated target path is explicitly supplied. No script should format disks or overwrite bootloaders based on guessed device names.

## 6. First-boot validation

Use a clean target VM and confirm GRUB loads the intended kernel, the kernel mounts the intended root filesystem, systemd reaches a text login, the filesystem table matches the VM layout, a normal user can log in, and no critical boot failures remain unresolved.

## 7. ISO validation

Design the ISO workflow after the installed base boots. Decide whether the first ISO is live, installer-based, or a bootable installation image. Test in a new VM with no existing disk state and publish a checksum with every image.

## 8. Reporting failures

Open an issue with the LFS edition, chapter/package, host details, exact command (excluding secrets), exit status, relevant log excerpt, and troubleshooting already attempted. Never upload private keys, access tokens, or personal data.
