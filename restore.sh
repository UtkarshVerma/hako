#!/bin/sh
set -eu

# Check if a backup file argument is provided, otherwise print usage.
if [ $# -ne 1 ]; then
    echo "usage: $0 <backup_file.tar.bz2>"
    exit 1
fi

BACKUP_FILE="$1"
if [ ! -f "$BACKUP_FILE" ]; then
    echo "error: backup file $BACKUP_FILE not found"
    exit 1
fi

exec tar --extract --verbose --bzip2 --file "$BACKUP_FILE"
