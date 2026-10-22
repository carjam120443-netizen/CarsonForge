# Configuration overlays

This directory is reserved for CarsonForge-owned configuration templates, such as future /etc/os-release, hostname, and MOTD defaults.

Do not place secrets, machine-specific device paths, generated credentials, or a full copied root filesystem here. Templates should be applied only by a reviewed build/install stage after the LFS base is verified.
