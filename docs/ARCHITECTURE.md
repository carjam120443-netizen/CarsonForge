# CarsonForge architecture

## Initial target

- **Architecture:** x86_64 / Gentoo `amd64`
- **Base:** Gentoo stage3
- **Package management:** Portage (`emerge`)
- **Init and service management:** systemd profile
- **Desktop:** XFCE
- **Networking:** NetworkManager
- **Source-install tracking:** Porg, built from source
- **First target image:** live desktop ISO
- **Test environment:** disposable virtual machines

These are design targets, not claims that the current BusyBox preview already contains them.

## Build layers

1. **Bootstrap:** download a pinned Gentoo stage3 and verify its published integrity data.
2. **Portage configuration:** select the target profile, compiler settings, USE flags, and package set.
3. **Target root:** build and install packages into an isolated Gentoo root filesystem.
4. **CarsonForge overlay:** add project identity, defaults, custom artwork, and reviewed startup configuration.
5. **Live image:** assemble kernel, bootloader, root filesystem, and live-session behavior into an ISO.
6. **Validation:** check required files and services, inspect the ISO, and boot it in a clean VM where runner capabilities permit.

## Repository responsibilities

- `docs/` describes architecture, build steps, and acceptance criteria.
- `scripts/` contains focused build and validation helpers.
- `config/` contains CarsonForge-owned configuration templates.
- `rootfs/` contains small project-owned overlay files, not a copied full system.
- `packages/` records future package definitions and provenance.
- `.github/workflows/` runs repository checks and the main ISO build.

The current BusyBox ISO builder is transitional and should not be mistaken for the Gentoo build pipeline.

## Reproducibility

Pin the stage3 snapshot and record the Gentoo profile, Portage configuration, package inputs, USE flags, and relevant environment. Cache downloaded source archives and build outputs when safe. Preserve logs and generate a checksum for each ISO. Do not claim bit-for-bit reproducibility until independently verified.

## Licensing and provenance

Gentoo artwork, Gentoo packages, patches, and third-party assets can have different licenses and usage conditions. The CarsonForge license does not override upstream terms. Preserve required notices and make it clear that CarsonForge is an independent project, not an official Gentoo release.
