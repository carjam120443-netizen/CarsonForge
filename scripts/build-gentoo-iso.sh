#!/usr/bin/env bash
# Experimental Gentoo stage3 -> Portage desktop -> squashfs live ISO pipeline.
set -Eeuo pipefail
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="${WORK_DIR:-$ROOT_DIR/work-gentoo}"
OUT_DIR="${OUT_DIR:-$ROOT_DIR/out}"
ROOTFS="$WORK_DIR/rootfs"
ISO_ROOT="$WORK_DIR/iso"
BOOT="$ISO_ROOT/boot"
STAGE3_BASE="https://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-systemd"
PACKAGES_FILE="$ROOT_DIR/packages/gentoo-packages.txt"
die() { printf 'error: %s\n' "$*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || die "Missing host command: $1"; }
[[ "$(uname -m)" == x86_64 ]] || die "This builder targets x86_64 only."
[[ $EUID -eq 0 ]] || die "Run as root on a disposable Linux build host."
for tool in curl tar sha512sum chroot mount umount mountpoint mksquashfs xorriso grub-mkrescue file; do need "$tool"; done
[[ -f "$PACKAGES_FILE" ]] || die "Missing package list: $PACKAGES_FILE"
mkdir -p "$WORK_DIR" "$OUT_DIR" "$ROOTFS" "$BOOT"
cleanup() { for target in dev/pts dev proc sys run; do mountpoint -q "$ROOTFS/$target" && umount -lf "$ROOTFS/$target" || true; done; }
trap cleanup EXIT

echo '::group::Download and verify Gentoo stage3'
curl --fail --location --retry 3 "$STAGE3_BASE/latest-stage3-amd64-systemd.txt" -o "$WORK_DIR/stage3.txt"
STAGE3_REL="$(awk '!/^#/ && /stage3-amd64-systemd-.*\.tar\.xz$/ {print $1; exit}' "$WORK_DIR/stage3.txt")"
[[ -n "$STAGE3_REL" ]] || die 'Could not find a systemd stage3 in latest-stage3-amd64-systemd.txt'
STAGE3_URL="$STAGE3_BASE/$STAGE3_REL"
curl --fail --location --retry 3 "$STAGE3_URL" -o "$WORK_DIR/stage3.tar.xz"
curl --fail --location --retry 3 "$STAGE3_URL.DIGESTS" -o "$WORK_DIR/stage3.DIGESTS"
STAGE3_NAME="$(basename "$STAGE3_REL")"
EXPECTED="$(awk -v name="$STAGE3_NAME" '$1 == "SHA512" && $2 == "HASH" && $4 == name {print $3; exit}' "$WORK_DIR/stage3.DIGESTS")"
ACTUAL="$(sha512sum "$WORK_DIR/stage3.tar.xz" | awk '{print $1}')"
[[ -n "$EXPECTED" && "$EXPECTED" == "$ACTUAL" ]] || die 'Stage3 SHA-512 verification failed against Gentoo DIGESTS.'
if [[ ! -x "$ROOTFS/bin/bash" ]]; then tar --numeric-owner -xpf "$WORK_DIR/stage3.tar.xz" -C "$ROOTFS"; fi
echo "Verified stage3: $STAGE3_REL"
echo '::endgroup::'

echo '::group::Configure isolated Gentoo root'
mkdir -p "$ROOTFS/etc/portage/package.use" "$ROOTFS/etc/NetworkManager/conf.d" "$ROOTFS/etc/lightdm/lightdm.conf.d" "$ROOTFS/etc/skel" "$ROOTFS/var/log"
install -m 0644 "$ROOT_DIR/config/portage/make.conf" "$ROOTFS/etc/portage/make.conf"
install -m 0644 "$ROOT_DIR/rootfs/etc/portage/package.use/carsonforge" "$ROOTFS/etc/portage/package.use/carsonforge"
cp -L /etc/resolv.conf "$ROOTFS/etc/resolv.conf"
printf '%s\n' 'NAME="CarsonForge"' 'ID=carsonforge' 'ID_LIKE="gentoo"' 'PRETTY_NAME="CarsonForge (Gentoo-based)"' 'VERSION="0.1.0-dev"' 'VERSION_ID="0.1.0-dev"' 'HOME_URL="https://github.com/carjam120443-netizen/CarsonForge"' 'SUPPORT_URL="https://github.com/carjam120443-netizen/CarsonForge/issues"' > "$ROOTFS/etc/os-release"
printf '%s\n' carsonforge > "$ROOTFS/etc/hostname"
cat > "$ROOTFS/etc/NetworkManager/conf.d/10-carsonforge.conf" <<'NM'
[main]
dhcp=internal
NM
for target in dev dev/pts proc sys run; do mkdir -p "$ROOTFS/$target"; done
mount --rbind /dev "$ROOTFS/dev"; mount --make-rslave "$ROOTFS/dev"
mount -t proc proc "$ROOTFS/proc"
mount --rbind /sys "$ROOTFS/sys"; mount --make-rslave "$ROOTFS/sys"
mount --rbind /run "$ROOTFS/run"; mount --make-rslave "$ROOTFS/run"
echo '::endgroup::'

echo '::group::Install Gentoo desktop through Portage'
cp "$PACKAGES_FILE" "$ROOTFS/tmp/carsonforge-packages.txt"
MAKE_JOBS="$(nproc)"
chroot "$ROOTFS" /bin/bash -euxc "source /etc/profile; export MAKEOPTS='-j${MAKE_JOBS}'; export EMERGE_DEFAULT_OPTS='--jobs=2 --load-average=2 --with-bdeps=y --getbinpkg'; emerge --sync; emerge --ask=n --verbose --update --deep --newuse @world; mapfile -t packages < <(grep -Ev '^[[:space:]]*(#|$)' /tmp/carsonforge-packages.txt); emerge --ask=n --verbose --getbinpkg=y \"\${packages[@]}\"; emerge --ask=n app-admin/porg; emerge --ask=n sys-kernel/dracut; systemctl enable NetworkManager; systemctl enable lightdm; systemctl set-default graphical.target; useradd --create-home --shell /bin/bash --groups wheel,audio,video carsonforge || true; passwd -l carsonforge; printf '[Seat:*]\\nautologin-user=carsonforge\\nautologin-session=xfce\\n' > /etc/lightdm/lightdm.conf.d/50-carsonforge-autologin.conf; emerge --info > /var/log/carsonforge-emerge-info.txt"
echo '::endgroup::'

echo '::group::Assemble experimental live ISO'
KERNEL="$(find "$ROOTFS/boot" -maxdepth 1 -type f \( -name 'vmlinuz-*' -o -name 'kernel-*' \) | sort -V | tail -n1)"
[[ -n "$KERNEL" ]] || die 'No kernel image found in target /boot; inspect Gentoo kernel package output.'
KVER="$(basename "$KERNEL" | sed -E 's/^(vmlinuz-|kernel-)//')"
chroot "$ROOTFS" /bin/bash -c "dracut --force --no-hostonly --kver '$KVER' --add 'dmsquash-live' /boot/carsonforge-initramfs.img"
install -m 0644 "$KERNEL" "$BOOT/vmlinuz"
install -m 0644 "$ROOTFS/boot/carsonforge-initramfs.img" "$BOOT/initramfs.img"
mkdir -p "$ISO_ROOT/LiveOS"
mksquashfs "$ROOTFS" "$ISO_ROOT/LiveOS/squashfs.img" -comp xz -b 1M -noappend -e proc sys dev run tmp
cat > "$BOOT/grub/grub.cfg" <<'GRUB'
set timeout=5
set default=0
menuentry 'CarsonForge Gentoo XFCE (experimental)' {
    linux /boot/vmlinuz rd.live.image rd.live.overlay.overlayfs=1 root=live:CDLABEL=CARSONFORGE
    initrd /boot/initramfs.img
}
GRUB
ISO="$OUT_DIR/carsonforge-gentoo-x86_64.iso"
grub-mkrescue -V CARSONFORGE -o "$ISO" "$ISO_ROOT"
[[ -s "$ISO" ]] || die 'ISO output is missing or empty.'
sha256sum "$ISO" | tee "$ISO.sha256"
file "$ISO"; ls -lh "$ISO"
echo '::endgroup::'
echo "Experimental Gentoo ISO created at $ISO"
echo 'A successful build does not prove a successful live boot; test in a disposable VM.'
