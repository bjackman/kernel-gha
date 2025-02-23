#!/bin/bash

# Builds the kernel and puts it in kernel.tgz.
# Needs to be run from the root of this repo.
set -eux -o pipefail

mkdir -p kernel-build
# Dunno how to point vng to the kernel tree so just cd in a subshell.
(cd linux/; ../virtme-ng/vng --kconfig)
# Build kernel
make -s -j $(( $(nproc) * 2 )) -C linux
# Just extract the important bits, Github is dumb and will copy the whole
# artifact between jobs every time which takes minutes if you include the whole
# build result.
make -j $(( $(nproc) * 2 )) -C linux INSTALL_PATH=$PWD/kernel-build install

# Shouldn't happen in GHA but when running locally the file might exist
if [ -e kernel-build/vmlinuz ]; then
    rm kernel-build/vmlinuz
fi

# Make a symlink that always has the same name
ln -s vmlinuz-$(make --no-print-directory -C linux kernelrelease) kernel-build/vmlinuz

# Github breaks file permissions so tar everything up
tar czf kernel.tgz -C kernel-build .
