#!/bin/sh
set -eu

BACKUP_DIR="${BACKUP_DIR:-backup}"

for backup in "$BACKUP_DIR"/*.tar.bz2; do
    service="${backup#"$BACKUP_DIR/"}"
    service="${service%.tar.bz2}"
    printf "Restoring %s..." "$service"
    state_dir="services/$service/state"
    mkdir -p "$state_dir"
    if {
        rm -rf "$state_dir:?"/*
        tar --directory "$state_dir" -xjf "$backup"
    }; then
        echo "done"
    else
        echo "failed"
    fi
done
