#!/bin/bash

# Runs the tests. Artifacts should be in the current directory under
# input-artifacts/rootfs/ and input-artifacts/kernel/

mkdir -p image

tar -C image  --zstd -xf input-artifacts/rootfs/image.tar.zst

unshare -r virtme-ng/vng --verbose \
            --root image --user root --run input-artifacts/kernel/vmlinuz \
            --rwdir=/mnt=input-artifacts/kernel/kselftest/kselftest_install -- \
              "cd /mnt/mm; ./run_vmtests.sh -t mmap"
