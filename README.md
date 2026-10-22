<div align="center">

<img src="https://upload.wikimedia.org/wikipedia/commons/2/23/Linux-From-Scratch_logo.png" alt="Linux From Scratch logo" width="192" height="75" />

<p><em>Built on the Linux From Scratch project — with credit to its contributors.</em></p>

<img src="https://raw.githubusercontent.com/carjam120443-netizen/CarsonForge/main/assets/carsonforge.png" alt="CarsonForge — built from source" width="600" />

<p>
  <img src="https://img.shields.io/badge/status-early%20development-orange" alt="Project status: early development" />
  <img src="https://img.shields.io/badge/architecture-x86__64-blue" alt="Target architecture: x86_64" />
  <img src="https://img.shields.io/badge/base-LFS%20systemd-informational" alt="Base: Linux From Scratch systemd" />
  <img src="https://img.shields.io/badge/interface-CLI--first-lightgrey" alt="CLI-first" />
</p>

</div>

# CarsonForge

**A Linux distribution built from source.**

CarsonForge is an experimental, CLI-first Linux distribution based on the official [Linux From Scratch (LFS) stable systemd book](https://www.linuxfromscratch.org/lfs/view/stable-systemd/index.html).

**Status: early planning / repository scaffolding.** CarsonForge is not yet a working distribution. The first milestone is a bootable x86_64 ISO, developed in verifiable stages. The initial system will be command-line first; desktop environments are out of scope until the base boots reliably.

## Principles

- Follow one pinned LFS book edition and its official errata.
- Keep builds logged, repeatable, and resumable where practical.
- Verify source checksums and signatures when upstream provides them.
- Keep the host separate from the target root filesystem.
- Test in disposable virtual machines before considering physical hardware.
- Distinguish CarsonForge-authored tooling from upstream LFS instructions and software.

## Roadmap

1. Repository foundation and host checks.
2. Dedicated Linux build VM and isolated target disk.
3. LFS cross-toolchain, temporary tools, chroot, and base system.
4. Kernel, systemd, filesystem table, GRUB, and first CLI boot.
5. ISO assembly and clean-VM testing.
6. CarsonForge identity: os-release, hostname, MOTD, and release metadata.
7. Later: package management improvements and optional desktop profiles.

See [ROADMAP](docs/ROADMAP.md), [BUILDING](docs/BUILDING.md), and [ARCHITECTURE](docs/ARCHITECTURE.md).

## First steps

Clone this repository and run the informational host inventory:

```bash
git clone https://github.com/carjam120443-netizen/CarsonForge.git
cd CarsonForge
chmod +x scripts/check-host.sh
./scripts/check-host.sh
```

This inventory is preliminary only; it does not replace the official LFS host-requirements checks. A full build and ISO generator do not exist yet. Read the [official LFS book](https://www.linuxfromscratch.org/lfs/view/stable-systemd/index.html) before preparing a build VM.

## Upstream references

- [LFS stable systemd book](https://www.linuxfromscratch.org/lfs/view/stable-systemd/index.html)
- [LFS errata](https://www.linuxfromscratch.org/lfs/errata/stable-systemd/)
- [Beyond Linux From Scratch](https://www.linuxfromscratch.org/blfs/)
- [LFS FAQ](https://www.linuxfromscratch.org/faq/)
- [LFS logo source and licensing information](https://commons.wikimedia.org/wiki/File:Linux-From-Scratch_logo.png)

## License and provenance

The repository license applies to eligible CarsonForge-authored files only. LFS instructions, package sources, patches, and assets retain their own licenses. The LFS logo is credited to its creators and is sourced from Wikimedia Commons; see the linked file page for licensing and attribution details. See the LFS book's license appendix and each upstream project's notices.

Issues should include the book edition, chapter/package, host details, exact command (without secrets), exit status, and relevant log excerpt.
