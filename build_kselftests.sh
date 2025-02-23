#!/bin/bash

# Builds the kselftests and puts them in kselftests.tgz
# Needs to be run from the root of this repo.
set -eux -o pipefail

mkdir -p kselftests-build

# -static is a simple way to workaround differences in the shared
# library environment between host & guest.
make -j $(( $(nproc) * 2 )) -C linux/tools/testing/selftests \
    TARGETS=mm KDIR=$PWD EXTRA_CFLAGS=-static O=$PWD install

# Github breaks file permissions so tar everything up
tar czf kselftests.tgz -C kselftest .
