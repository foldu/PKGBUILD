#!/usr/bin/env bash
set -euo pipefail

# REMINDER: do _not_ mount /var/cache/pacman/pkg because pacman likes
# deleting everything in it

if [ $# -lt 1 ]; then
    echo "test.sh [DIRECTORIES]..."
    exit 1
fi

sudo podman build . -t arch-tester

for dir in "$@"; do
    if echo $dir | grep ':' -q; then
        echo ": detected in package name, exiting"
        exit 1
    fi

    echo "Testing $dir in a clean build environment"
    cleaned_dir=$(echo $dir | sed 's/\/*$//g')
    cleaned_dir=$(realpath "$cleaned_dir")

    echo $cleaned_dir
    sudo podman run \
        -v "$cleaned_dir:/build" \
        arch-tester \
        sh -c "chmod +rw /build -R && sudo -u build sh -c 'cd /build && makepkg -s --noconfirm'"
done
