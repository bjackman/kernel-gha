#!/bin/bash

# Builds the kernel and selftests.
# Needs to be run from the root of this repo.
# Drops everything into ./build/
set -eux -o pipefail

mkdir -p build
# Dunno how to point vng to the kernel tree so just cd in a subshell.
(cd linux/; ../virtme-ng/vng -b O=../build)

# -static is a simple way to workaround differences in the shared
# library environment between host & guest.
make -j $(( $(nproc) * 2 )) -C linux/tools/testing/selftests \
    TARGETS=mm KDIR=$PWD EXTRA_CFLAGS=-static O=$PWD/build install
