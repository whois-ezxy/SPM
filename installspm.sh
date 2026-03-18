#!/bin/sh
set -e

REPO_USER="whois-ezxy"
REPO_NAME="SPM"
BRANCH="main"

# --- Detect environment ---
if [ -d /mnt/stateful_partition ]; then
  SPM_MODE="chromeos"
  SPM_PKGS_ROOT="/mnt/stateful_partition/spm/pkgs"
  SPM_DB="/mnt/stateful_partition/spm/db"
else
  SPM_MODE="linux"
  SPM_PKGS_ROOT="/usr/local/spm/pkgs"
  SPM_DB="/usr/local/var/spm"
fi

SPM_BIN="/usr/local/bin/spm"

echo "[SPM] Mode: $SPM_MODE"
echo "[SPM] PKGS_ROOT: $SPM_PKGS_ROOT"
echo "[SPM] DB: $SPM_DB"

# --- Create dirs ---
sudo mkdir -p "$SPM_PKGS_ROOT" "$SPM_DB" /usr/local/bin

# --- Fetch spm script from bin/spm
SPM_URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${BRANCH}/bin/spm"

echo "[SPM] Downloading spm from:"
echo "      $SPM_URL"

curl -fsSL "$SPM_URL" | sudo tee "$SPM_BIN" >/dev/null
sudo chmod +x "$SPM_BIN"

echo "[SPM] Installed /usr/local/bin/spm"
echo "[SPM] SPM is fully set up, grab some packages"
