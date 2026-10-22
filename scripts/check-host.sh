#!/usr/bin/env bash
# CarsonForge preliminary host inventory.
# Informational only; official LFS host checks remain authoritative.
set -u

section() { printf '\n== %s ==\n' "$1"; }

section "CarsonForge host inventory"
printf 'Timestamp: '
date -u '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || printf 'unavailable\n'
printf 'Kernel: '
uname -srmo 2>/dev/null || printf 'unavailable\n'
printf 'Distribution: '
if [ -r /etc/os-release ]; then
  . /etc/os-release
  printf '%s %s\n' "${NAME:-unknown}" "${VERSION_ID:-unknown}"
else
  printf 'unknown (/etc/os-release unavailable)\n'
fi

section "Required command inventory"
missing=0
for cmd in bash sh env uname gcc g++ ld make bison awk perl python3 tar xz patch sed find; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf 'OK      %-10s %s\n' "$cmd" "$(command -v "$cmd")"
  else
    printf 'MISSING %-10s\n' "$cmd"
    missing=1
  fi
done

section "Compiler and linker versions"
for cmd in gcc g++ ld make bison awk perl python3; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '\n-- %s --\n' "$cmd"
    case "$cmd" in
      gcc|g++|make|bison|perl|python3) "$cmd" --version 2>&1 | head -n 2 ;;
      ld) ld --version 2>&1 | head -n 1 ;;
      awk) awk -W version 2>&1 | head -n 2 ;;
    esac
  fi
done

section "Storage and identity"
printf 'User: '
id 2>/dev/null || true
printf '\nFilesystem overview:\n'
df -h . 2>/dev/null || true
printf '\n'

if [ "$missing" -ne 0 ]; then
  printf 'Preliminary result: commands are missing. Consult the selected LFS book.\n'
else
  printf 'Preliminary result: inventoried commands were found. This is NOT an LFS host-requirements pass.\n'
fi
printf 'No disks were formatted, no files were changed, and no packages were installed.\n'
