# Root filesystem overlay

This directory is reserved for small, project-owned files that will be layered onto a completed LFS root filesystem. It is not a built root filesystem and should not contain generated system files, credentials, or machine-specific disk configuration.

Add overlay files only when the build stage that installs them is documented and tested.
