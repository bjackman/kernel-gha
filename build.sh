#!/bin/bash

# Builds the kernel and selftests.
# Needs to be run from the root of this repo.
# Drops everything into ./build/
set -eux -o pipefail

mkdir -p build
# Dunno how to point vng to the kernel tree so just cd in a subshell.
(cd linux/; ../virtme-ng/vng --kconfig)
# Build kernel
make -s -j $(( $(nproc) * 2 )) -C linux
# Just extract the important bits, Github is dumb and will copy the whole
# artifact between jobs every time which takes minutes if you include the whole
# build result.
make -j $(( $(nproc) * 2 )) -C linux INSTALL_PATH=$PWD/build install
# Make a symlink that always has the same name
ln -s vmlinuz-$(make --no-print-directory -C linux kernelrelease) build/vmlinuz

# -static is a simple way to workaround differences in the shared
# library environment between host & guest.
make -j $(( $(nproc) * 2 )) -C linux/tools/testing/selftests \
    TARGETS=mm KDIR=$PWD EXTRA_CFLAGS=-static O=$PWD/build install
