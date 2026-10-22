#!/usr/bin/env bash
# Build and install Porg from an already-extracted source tree, inside CarsonForge's LFS environment.
# The bootstrap installation itself cannot be logged by Porg before Porg exists.
set -Eeuo pipefail

usage() {
  echo "Usage: $0 /path/to/extracted-porg-source [--prefix=/usr]" >&2
  exit 2
}
[[ $# -ge 1 && $# -le 2 ]] || usage
SRC="$(realpath "$1")"
PREFIX="${2:---prefix=/usr}"
[[ "$PREFIX" == --prefix=* ]] || usage
[[ -f "$SRC/configure" ]] || {
  echo "error: '$SRC/configure' not found; pass the extracted Porg source directory." >&2
  exit 1
}
for cmd in make; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "error: required build tool '$cmd' is missing." >&2
    exit 1
  }
done

JOBS="${JOBS:-$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 2)}"
case "$JOBS" in ''|*[!0-9]*) echo "error: JOBS must be a positive integer." >&2; exit 2;; esac
(( JOBS > 0 )) || { echo "error: JOBS must be greater than zero." >&2; exit 2; }

cd "$SRC"
./configure "$PREFIX"
make -j"$JOBS"
if [[ $EUID -eq 0 ]]; then
  make install
else
  echo "error: install requires root inside the disposable LFS target/chroot." >&2
  echo "Build as an unprivileged LFS user, then run 'make install' as root after reviewing the build." >&2
  exit 1
fi

mkdir -p /var/lib/porg
chmod 0755 /var/lib/porg
if ! command -v porg >/dev/null 2>&1; then
  echo "error: Porg installation completed but 'porg' is not on PATH." >&2
  exit 1
fi
echo "Porg installed. Its bootstrap install was not tracked; use porg -lD -- make install for later source packages."
