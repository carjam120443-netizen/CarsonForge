# Configuration overlays

This directory holds CarsonForge-owned configuration templates, such as future `os-release`, hostname, live-session, and desktop defaults.

Templates should be applied by a reviewed build stage to the isolated Gentoo target root. Do not place secrets, machine-specific device paths, generated credentials, or a copied full root filesystem here. Keep upstream Gentoo configuration and CarsonForge-specific defaults clearly distinguished.
