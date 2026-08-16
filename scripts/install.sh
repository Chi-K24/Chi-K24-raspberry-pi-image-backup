#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${EUID}" -ne 0 ]]; then
    echo "Run this installer with sudo." >&2
    exit 1
fi

readonly PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v image-backup >/dev/null 2>&1; then
    echo "image-backup is not installed." >&2
    echo "Install RonR-RPi-image-utils first; see README.md." >&2
    exit 1
fi

install -d -m 0755 /etc/image-backup
install -m 0755 "${PROJECT_ROOT}/scripts/rpi-image-backup-weekly" /usr/local/sbin/rpi-image-backup-weekly
install -m 0644 "${PROJECT_ROOT}/systemd/rpi-image-backup.service" /etc/systemd/system/rpi-image-backup.service
install -m 0644 "${PROJECT_ROOT}/systemd/rpi-image-backup.timer" /etc/systemd/system/rpi-image-backup.timer

if [[ ! -e /etc/rpi-image-backup.conf ]]; then
    install -m 0600 "${PROJECT_ROOT}/config/rpi-image-backup.conf.example" /etc/rpi-image-backup.conf
    echo "Created /etc/rpi-image-backup.conf"
else
    echo "Preserved existing /etc/rpi-image-backup.conf"
fi

if [[ ! -e /etc/image-backup/excludes.txt ]]; then
    install -m 0644 "${PROJECT_ROOT}/config/excludes.txt.example" /etc/image-backup/excludes.txt
    echo "Created /etc/image-backup/excludes.txt"
else
    echo "Preserved existing /etc/image-backup/excludes.txt"
fi

systemctl daemon-reload

echo
echo "Installation complete."
echo "Review /etc/rpi-image-backup.conf and /etc/image-backup/excludes.txt."
echo "Then enable the timer with:"
echo "  sudo systemctl enable --now rpi-image-backup.timer"
