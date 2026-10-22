# CarsonForge architecture

## Initial target

- Architecture: x86_64 (planned; not yet validated)
- Init/service manager: systemd, following the selected LFS systemd book
- Interface: CLI-first
- Development target: isolated virtual machines
- First deliverable: bootable ISO, after a verified installed base system

## Layers

1. **Upstream LFS base:** toolchain, C library, core utilities, shell, system utilities, kernel, and system configuration built according to the pinned book.
2. **CarsonForge configuration:** project identity and documented defaults layered on the completed LFS system.
3. **Image assembly:** a separately tested process packaging a known-good root filesystem into a bootable ISO.
4. **Future components:** package-management strategy, installer, and optional desktop profiles. These are not assumed to exist in the initial CLI release.

## Repository responsibilities

- docs/ describes build procedure, architecture, and acceptance criteria.
- scripts/ contains host checks and later reviewed stage-specific automation.
- config/ holds CarsonForge-owned configuration templates.
- rootfs/ holds small project-owned overlay files, not a copied built root filesystem.
- packages/ will document future package definitions and provenance.
- .github/workflows/ performs repository checks; it should not attempt a full LFS build until runner resources and reproducibility are designed.

## Reproducibility

Record the book edition, package inputs, patches, configuration, and build environment. Prefer explicit versions and verified checksums. Preserve logs. Do not claim bit-for-bit reproducibility until independently verified.

## Licensing and provenance

LFS instructions, packages, patches, and assets may have different licenses. The CarsonForge license does not override upstream terms. Preserve required notices and source links for redistributed materials.
