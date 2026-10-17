#!/usr/bin/env bash
#
# disk-cleanup.sh — report disk usage and safely free space on Debian/Ubuntu
#
# Usage:
#   sudo ./disk-cleanup.sh
#
# What it does:
#   - shows disk usage before/after
#   - lists the 10 biggest directories under /var (where space usually hides)
#   - cleans the apt package cache
#   - trims systemd journals older than 7 days
#   - clears the current user's thumbnail cache
#
# Everything it deletes is regenerable cache/log data — no user files touched.
#
set -euo pipefail

echo "=== Disk usage BEFORE ==="
df -h /

echo
echo "=== Top 10 directories under /var ==="
du -xh /var 2>/dev/null | sort -rh | head -10

echo
echo "=== Cleaning: apt cache, journals older than 7d, thumbnails ==="
apt-get clean
journalctl --vacuum-time=7d >/dev/null
rm -rf ~/.cache/thumbnails/* 2>/dev/null || true

echo
echo "=== Disk usage AFTER ==="
df -h /
