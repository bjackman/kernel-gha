#!/bin/bash

mkdir -p image
tar -C image  --zstd -xf image.tar.zst

mkdir -p kernel
tar -C kernel  -zxf kernel.tgz

unshare -r virtme-ng/vng --verbose \
    --root image --user root --run input-artifacts/kernel/vmlinuz \
    --rwdir=/mnt=input-artifacts/kernel/kselftest/kselftest_install -- \
        "cd /mnt/mm; ./run_vmtests.sh -t mmap"
