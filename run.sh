#!/bin/bash
set -eux

# This runs inside the container.

echo "yep"

cd /src/linux/

# vng --kconfig
# make -s -j $(nproc)

vng --verbose -- ls /