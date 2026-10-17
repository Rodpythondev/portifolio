#!/usr/bin/env bash
#
# sysupdate.sh — safe unattended update for Debian/Ubuntu servers
#
# Usage:
#   sudo ./sysupdate.sh
#   # or schedule it weekly with cron:
#   # 0 4 * * 0 root /path/to/sysupdate.sh
#
# What it does:
#   - updates the package list, upgrades everything
#   - removes orphaned packages and stale .deb cache
#   - logs everything to /var/log/sysupdate.log
#   - warns if a reboot is required (never reboots by itself)
#
set -euo pipefail

LOG="/var/log/sysupdate.log"

# Send all output both to the terminal and to the log file.
exec > >(tee -a "$LOG") 2>&1

echo "=== $(date '+%F %T'): starting system update ==="

apt-get update -qq
apt-get upgrade -y -qq
apt-get autoremove -y -qq
apt-get autoclean -qq

echo "=== $(date '+%F %T'): update finished ==="

if [ -f /var/run/reboot-required ]; then
    echo "NOTE: a reboot is required — restart the machine when convenient."
fi
