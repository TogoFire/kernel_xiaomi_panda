#!/usr/bin/env bash
# Android Kernel Build Script

# Setup the build environment
git clone --depth=1 https://github.com/akhilnarang/scripts environment
cd environment && bash setup/android_build_env.sh && cd ..

# Clone proton clang from kdrag0n's repo
git clone --depth=1 https://github.com/kdrag0n/proton-clang proton-clang

# Clone AnyKernel3
git clone --depth=1 https://github.com/TogoFire/AnyKernel3 AnyKernel3

BUILD_START=$(date +"%s")
PATH="$(pwd)/proton-clang/bin:$PATH"

export PATH

# Clean up out
rm -rf out/*

# Compile the kernel
build_clang() {
    make -j"$(nproc --all)" \
    O=out \
    ARCH=arm64 \
    CC=clang \
    CXX=clang++ \
    AR=llvm-ar \
    AS=llvm-as \
    NM=llvm-nm \
    LD=ld.lld \
    STRIP=llvm-strip \
    OBJCOPY=llvm-objcopy \
    OBJDUMP=llvm-objdump\
    OBJSIZE=llvm-size \
    READELF=llvm-readelf \
    HOSTCC=clang \
    HOSTCXX=clang++ \
    HOSTAR=llvm-ar \
    HOSTAS=llvm-as \
    HOSTNM=llvm-nm \
    HOSTLD=ld.lld \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi-
}

make O=out ARCH=arm64 daisy_defconfig
build_clang

# Calculate how long compiling compiling the kernel took
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))

# Zip up the kernel
zip_kernelimage() {
    rm -rf "$(pwd)"/AnyKernel3/Image.gz-dtb
    cp "$(pwd)"/out/arch/arm64/boot/Image.gz-dtb AnyKernel3
    rm -rf "$(pwd)"/AnyKernel3/*.zip
    BUILD_TIME=$(date +"%d%m%Y-%H%M")
    cd AnyKernel3 || exit
    zip -r9 Panda-r"${RELEASE}"-"${BUILD_TIME}".zip ./*
    cd ..
}

# Get MD5SUM and SHASUM of the zipped kernel
Hash() {
    SHA=$(shasum "$(pwd)"/AnyKernel3/Panda-r"${RELEASE}"-"${BUILD_TIME}".zip | cut -f 1 -d '/')
    MD5=$(md5sum "$(pwd)"/AnyKernel3/Panda-r"${RELEASE}"-"${BUILD_TIME}".zip | cut -f 1 -d '/')
}

FILE="$(pwd)/out/arch/arm64/boot/Image.gz-dtb"
if [ -f "$FILE" ]; then
    zip_kernelimage
    Hash
    echo "The kernel has successfully been compiled and can be found in $(pwd)/AnyKernel3/Panda-r${RELEASE}-${BUILD_TIME}.zip"
    echo "md5: $MD5"
    echo "sha: $SHA"
    read -r -p "Press enter to continue"
fi
