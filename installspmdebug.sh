#!/bin/sh
set -e

REPO_USER="whois-ezxy"
REPO_NAME="SPM"
BRANCH="main"

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
SPM_URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${BRANCH}/bin/spm"

sudo mkdir -p "$SPM_PKGS_ROOT" "$SPM_DB" /usr/local/bin
sudo touch "$SPM_DB/status.db"

tmp="$(mktemp)"
curl -fsSL "$SPM_URL" -o "$tmp"
sudo cp "$tmp" "$SPM_BIN"
sudo chmod +x "$SPM_BIN"
rm -f "$tmp"
echo "SPM: install complete!"
