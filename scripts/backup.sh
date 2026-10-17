#!/usr/bin/env bash
#
# backup.sh — simple rotating backup of any directory
#
# Usage:
#   ./backup.sh /path/to/source /path/to/backups
#
# What it does:
#   - creates a timestamped .tar.gz of the source directory
#   - appends every run to backup.log
#   - keeps only the newest 7 archives (rotation)
#
set -euo pipefail

SOURCE="${1:?Usage: backup.sh <source_dir> <backup_dir>}"
DEST="${2:?Usage: backup.sh <source_dir> <backup_dir>}"
KEEP=7

DATE=$(date +%Y%m%d-%H%M%S)
ARCHIVE="$DEST/backup-$DATE.tar.gz"
LOG="$DEST/backup.log"

mkdir -p "$DEST"

echo "[$DATE] Starting backup of $SOURCE" | tee -a "$LOG"

if tar -czf "$ARCHIVE" \
        -C "$(dirname "$SOURCE")" "$(basename "$SOURCE")" 2>>"$LOG"; then
    echo "[$DATE] OK: $ARCHIVE" | tee -a "$LOG"
else
    echo "[$DATE] FAILED: tar exited with $?" | tee -a "$LOG"
    exit 1
fi

# Rotation: list archives newest-first, delete everything past the $KEEP newest.
ls -1t "$DEST"/backup-*.tar.gz 2>/dev/null \
    | tail -n +$((KEEP + 1)) \
    | xargs -r rm --
echo "[$DATE] Rotation done (keeping $KEEP newest)" | tee -a "$LOG"
