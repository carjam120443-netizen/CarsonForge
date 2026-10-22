<div align="center">

<img src="https://commons.wikimedia.org/wiki/Special:FilePath/Gentoo_Linux.svg" alt="Official Gentoo Linux logo" width="150" />

<p><em>Gentoo-based · Portage-powered · Source-built</em></p>

<img src="https://raw.githubusercontent.com/carjam120443-netizen/CarsonForge/main/assets/carsonforge.png" alt="CarsonForge custom logo" width="420" />

<p>
  <img src="https://img.shields.io/badge/status-early%20development-orange" alt="Project status: early development" />
  <img src="https://img.shields.io/badge/target-x86--64-blue?style=flat-square" alt="Target architecture: x86-64 (amd64)" />
  <img src="https://img.shields.io/badge/base-Gentoo-informational" alt="Base: Gentoo Linux" />
  <img src="https://img.shields.io/badge/desktop-XFCE-4a6b8a" alt="Planned desktop: XFCE" />
</p>

</div>

# CarsonForge

**A Gentoo-based Linux distribution focused on source-built software.**

CarsonForge uses Gentoo and Portage as its foundation. The goal is a practical, source-first desktop system that builds most packages through Portage while using Gentoo's existing ecosystem instead of maintaining an entire Linux userspace from scratch.

**Status: early development.** An experimental Gentoo stage3 → Portage → XFCE ISO build pipeline is now in the repository, alongside the older BusyBox developer preview. The Gentoo workflow is an initial scaffold and has not yet been confirmed to build or boot successfully. The target is an x86_64 live ISO with XFCE, NetworkManager, and Porg.

## Goals

- Use a pinned Gentoo stage3 and documented Portage configuration.
- Build most system packages from source through Portage.
- Provide an XFCE live desktop with NetworkManager enabled.
- Build Porg from source and include it in the target system.
- Keep the build repeatable, logged, and cache-friendly.
- Test the generated ISO in a clean virtual machine before calling it usable.
- Keep CarsonForge's own branding and tools distinct from upstream Gentoo software.

## Roadmap

1. Replace the legacy BusyBox preview build with a Gentoo stage3 bootstrap.
2. Build a minimal systemd-based Gentoo root filesystem through Portage.
3. Add NetworkManager, DHCP support, and suitable firmware where redistribution is permitted.
4. Build Porg from source and verify it works in the target root.
5. Build the Xorg/graphics stack and XFCE desktop profile.
6. Create a live ISO with a bootloader, live-session startup, and writable runtime state.
7. Add ISO integrity checks and automated VM boot smoke tests where runner capabilities allow.

See [Architecture](docs/ARCHITECTURE.md), [Building](docs/BUILDING.md), [Roadmap](docs/ROADMAP.md), and [Desktop, networking, and Porg](docs/NETWORKING-XFCE-PORG.md).

## Repository layout

- `assets/` — CarsonForge-authored branding.
- `config/` — project-owned configuration templates.
- `docs/` — architecture, build plan, and acceptance criteria.
- `packages/` — planned package and provenance notes.
- `rootfs/` — small project-owned overlay files; not a complete operating system.
- `scripts/` — reviewed build and validation helpers.
- `.github/workflows/` — repository checks and ISO build automation.

## Build workflows

- **Build CarsonForge Gentoo XFCE ISO (experimental):** manually run `.github/workflows/build-gentoo-iso.yml` from the Actions tab, or let it run when its build inputs change. It bootstraps Gentoo stage3, installs the initial package set through Portage, and attempts to assemble a squashfs live ISO. The first run may expose package, disk, runner-time, or live-boot issues; no successful build or VM boot is claimed yet.
- **Build CarsonForge legacy BusyBox preview ISO:** the older workflow remains available during the transition. Its `carsonforge-base-x86_64-iso` artifact boots to a BusyBox shell and does **not** contain Gentoo, XFCE, NetworkManager, or Porg.

Treat the new image as experimental until a workflow run succeeds and the ISO has been tested in a disposable VM.

## Upstream and branding

- [Gentoo Linux](https://www.gentoo.org/)
- [Gentoo Handbook](https://wiki.gentoo.org/wiki/Handbook:AMD64)
- [Gentoo Portage documentation](https://wiki.gentoo.org/wiki/Portage)
- [Official Gentoo artwork](https://www.gentoo.org/inside-gentoo/artwork/gentoo-logo.html)
- [Gentoo name and logo usage guidelines](https://www.gentoo.org/inside-gentoo/foundation/name-logo-guidelines.html)
- [Porg project](https://porg.sourceforge.net/)

The Gentoo logo is upstream artwork and remains subject to Gentoo's attribution, license, and name/logo guidelines. The CarsonForge logo and branding remain separate project assets. CarsonForge is an independent project and is not an official Gentoo release.

## License and provenance

The repository license applies only to eligible CarsonForge-authored files. Gentoo artwork, package sources, patches, and third-party assets retain their own license and usage terms. Preserve upstream notices and document source provenance when redistributing them.

Issues should include the commit or workflow run, the exact failed step, exit status, and a relevant log excerpt. Do not include passwords, tokens, or other secrets.
