#!/bin/bash

# Runs the tests. Artifacts should be in the current directory under
# input-artifacts/rootfs/ and input-artifacts/kernel/

mkdir -p image

umask 0000

tar --version

sha1sum input-artifacts/rootfs/image.tar.zst
zstd -d -c input-artifacts/rootfs/image.tar.zst | tar -C image --preserve-permissions -xf -
tar --list -v --zstd -f input-artifacts/rootfs/image.tar.zst

ls -l input-artifacts/kernel/kselftest/kselftest_install/mm

unshare -r virtme-ng/vng \
    --root image --user root --run input-artifacts/kernel/vmlinuz \
    --rwdir=/mnt=input-artifacts/kernel/kselftest/kselftest_install -- \
        "cd /mnt/mm; ls -l ; bash ./run_vmtests.sh -t mmap"
