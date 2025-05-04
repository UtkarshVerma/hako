#!/bin/sh
set -eu

BACKUP_DIR="${BACKUP_DIR:-backups}"
TARFILE="$BACKUP_DIR/$(date +"%Y-%m-%d_%H-%M-%S").tar"

get_enabled_services() {
    # Extract service names from compose.yaml.
    awk '
        $1 == "-" && $2 ~ /\.\/services\/.*\/compose\.yaml/ {
        gsub("./services/|/compose.yaml", "", $2)
        print $2
    }' compose.yaml
}

echo "Pausing containers"
must_unpause=1
if ! docker compose pause; then
    must_unpause=0
fi

if [ $must_unpause -eq 1 ]; then
    unpause() {
        echo "Unpausing containers"
        docker compose unpause
    }

    trap unpause EXIT TERM
fi

mkdir -p "$BACKUP_DIR"
tar --create --file "$TARFILE" .env
for service in $(get_enabled_services); do
    state_dir="services/$service/state"
    if [ -d "$state_dir" ]; then
        printf "Backing up %s..." "$service"
        if tar --append --file "$TARFILE" --exclude "$state_dir/.gitignore" "$state_dir"; then
            echo "done"
        else
            echo "failed"
        fi
    else
        echo "Warning: $state_dir not found, skipping"
    fi
done

# Compressed tarballs cannot be appended to, therefore, the accumulation
# happens on an uncompressed tarball and compression is done at the end.
printf "Compresssing tarball..."
if bzip2 --best "$TARFILE"; then
    echo "done"
    echo "Backup created at $TARFILE.bz2"
else
    echo "failed"
fi
