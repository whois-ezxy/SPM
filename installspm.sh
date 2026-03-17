#!/bin/sh
# Usage:
#   ./install_spm_pkg.sh <package-filename>
# Example:
#   ./install_spm_pkg.sh my-tool-linux-amd64.tar.zst

set -e

REPO_USER="whois-ezxy"
REPO_NAME="SPM"
BRANCH="main"

PKG_FILE="$1"
[ -z "$PKG_FILE" ] && { echo "Usage: $0 <package-filename>"; exit 1; }

# --- Detect environment: ChromeOS vs generic Linux ---
if [ -d /mnt/stateful_partition ]; then
  MODE="chromeos"
  SPM_PKGS_ROOT="/mnt/stateful_partition/spm/pkgs"
  SPM_DB="/mnt/stateful_partition/spm/db"
else
  MODE="linux"
  SPM_PKGS_ROOT="/usr/local/spm/pkgs"
  SPM_DB="/usr/local/var/spm"
fi

mkdir -p "$SPM_PKGS_ROOT" "$SPM_DB"

# --- Build raw GitHub URL for the package ---
PKG_URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${BRANCH}/packages/${PKG_FILE}"

DEST="${SPM_PKGS_ROOT}/${PKG_FILE}"

echo "[SPM] Mode: $MODE"
echo "[SPM] Downloading ${PKG_FILE} from:"
echo "      ${PKG_URL}"
echo "[SPM] Saving to: ${DEST}"

wget -qO "$DEST" "$PKG_URL" || { echo "[SPM] Download failed"; rm -f "$DEST"; exit 1; }

# --- Extract into /usr/local ---
echo "[SPM] Extracting into /usr/local ..."

case "$DEST" in
  *.tar.gz|*.tgz)
    sudo tar xzf "$DEST" -C /usr/local --overwrite --no-same-owner
    ;;
  *.tar.xz)
    sudo tar xJf "$DEST" -C /usr/local --overwrite --no-same-owner
    ;;
  *.tar.zst)
    sudo tar --use-compress-program=zstd -xf "$DEST" -C /usr/local --overwrite --no-same-owner
    ;;
  *)
    echo "[SPM] Unknown archive type: $DEST"
    exit 1
    ;;
esac

# --- Record install ---
echo "${PKG_FILE} $(date -Iseconds) ${MODE}" >> "${SPM_DB}/installed"

echo "[SPM] Installed ${PKG_FILE} to /usr/local"
