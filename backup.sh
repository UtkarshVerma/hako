#!/bin/sh
set -eu

BACKUP_DIR="${BACKUP_DIR:-backup}"

echo "Pausing containers"
must_unpause=1
if ! docker compose pause; then
    must_unpause=0
fi

if [ $must_unpause -eq 1 ]; then
    unpause() {
        printf "Unpausing containers"
        docker compose unpause
    }

    trap unpause EXIT TERM
fi

mkdir -p "${BACKUP_DIR}"
for state_dir in services/*/state; do
    service="${state_dir%/state}"
    service="${service#services/}"
    printf "Backing up %s..." "$service"
    if
        tar --create --bzip2 --file "$BACKUP_DIR/$service.tar.bz2" --directory "$state_dir" .
    then
        echo "done"
    else
        echo "failed"
    fi
done
