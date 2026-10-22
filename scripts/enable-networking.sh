#!/usr/bin/env bash
# Enable NetworkManager in an already-built CarsonForge target root.
# This configures a target; it does not build/install NetworkManager or its dependencies.
set -Eeuo pipefail

usage() {
  echo "Usage: $0 /path/to/target-root" >&2
  echo "NetworkManager and its systemd unit must already be installed in that root." >&2
  exit 2
}
[[ $# -eq 1 ]] || usage
ROOT="$(realpath -m "$1")"
[[ -d "$ROOT/etc" && -d "$ROOT/usr" ]] || {
  echo "error: '$ROOT' does not look like an assembled target root (expected etc/ and usr/)." >&2
  exit 1
}
[[ $EUID -eq 0 ]] || {
  echo "error: run as root to write the target root." >&2
  exit 1
}

UNIT=""
for candidate in \
  "$ROOT/usr/lib/systemd/system/NetworkManager.service" \
  "$ROOT/lib/systemd/system/NetworkManager.service"; do
  if [[ -f "$candidate" ]]; then UNIT="$candidate"; break; fi
done
[[ -n "$UNIT" ]] || {
  echo "error: NetworkManager.service is missing from '$ROOT'." >&2
  echo "Build/install NetworkManager and its BLFS dependencies first." >&2
  exit 1
}

mkdir -p "$ROOT/etc/NetworkManager" \
  "$ROOT/etc/systemd/system/multi-user.target.wants"
if [[ ! -e "$ROOT/etc/NetworkManager/NetworkManager.conf" ]]; then
  cat > "$ROOT/etc/NetworkManager/NetworkManager.conf" <<'CONF'
[main]
plugins=keyfile
CONF
fi

unit_rel="${UNIT#"$ROOT"}"
link="$ROOT/etc/systemd/system/multi-user.target.wants/NetworkManager.service"
ln -sfn "$unit_rel" "$link"

echo "Enabled NetworkManager for target root: $ROOT"
echo "Unit: $unit_rel"
echo "Configuration: $ROOT/etc/NetworkManager/NetworkManager.conf"
echo "Next: boot the target and verify DHCP, DNS, and adapter-specific Wi-Fi support."
