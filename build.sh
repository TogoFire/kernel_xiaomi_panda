#!/usr/bin/env bash
# Android Kernel Build Script

# Kernel building script

# Setup colour for the script
yellow='\033[0;33m'
white='\033[0m'
red='\033[0;31m'
green='\e[0;32m'

##------------------------------------------------------## 

# Function to show an informational message
msg() {
    echo -e "\e[1;32m$*\e[0m"
}

err() {
    echo -e "\e[1;41m$*\e[0m"
    exit 1
}

##------------------------------------------------------##

# Setup the build environment
AKHILNARANG="environment"
msg $green "|| Clone & Build environment ||" $white

# Check if $DIR exists or not
if test ! -d "$AKHILNARANG"
then
    echo -e "$yellow $AKHILNARANG not found, downloading $white"
    git clone --depth=1 https://github.com/TogoFire/scripts ${AKHILNARANG}
    cd ${AKHILNARANG} && bash setup/opensuse.sh
    cd ..
    else
    echo -e "$yellow $AKHILNARANG found, skipping step $white"
fi

# Clone clang
CLANG_VERSION="clang-neutron"
    echo " "
    msg $green "|| Cloning Clang ||" $white

# Check if $DIR exists or not
if test ! -d "$CLANG_VERSION"
then
    echo -e "$yellow $CLANG_VERSION not found, downloading $white"
    mkdir ${CLANG_VERSION}
    cd ${CLANG_VERSION}
    bash <(curl -s "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman") -S
    cd ..
    else
    echo -e "$yellow $CLANG_VERSION found, checking updates & skip step $white"
    cd ${CLANG_VERSION}
    bash <(curl -s "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman") -U
    bash <(curl -s "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman") -I
    cd ..
fi

##------------------------------------------------------##

# Clone AnyKernel3
ANYKERNEL3_VERSION="AnyKernel3"
	echo " "
	msg $green "|| Cloning AnyKernel3 ||" $white
# Check if $DIR exists or not
if test ! -d "$ANYKERNEL3_VERSION"
then
    echo -e "$yellow $ANYKERNEL3_VERSION not found, downloading $white"
    git clone --depth=1 https://github.com/TogoFire/AnyKernel3 -b panda ${ANYKERNEL3_VERSION}
    else
    echo -e "$yellow $ANYKERNEL3_VERSION found, skipping step $white"
fi    

BUILD_START=$(date +"%s")
PATH="$(pwd)/${CLANG_VERSION}/bin:$PATH"

export PATH

# Clean up out
rm -rf out/*
rm -rf error.log

##------------------------------------------------------##

# Compile the kernel
msg $yellow "|| 🔨 Started Compilation ||" $white
CLANG_ROOTDIR=$(pwd)/${CLANG_VERSION}
TOOLCHAIN="clang"

build_kernel() {
Start=$(date +"%s")

if [ "$TOOLCHAIN" == ${TOOLCHAIN} ]; then
    echo " "
    make -j$(nproc) ARCH=arm64 SUBARCH=arm64 O=out \
        CC=${CLANG_ROOTDIR}/bin/clang \
        LD=${CLANG_ROOTDIR}/bin/ld.lld \
        AR=${CLANG_ROOTDIR}/bin/llvm-ar \
        AS=${CLANG_ROOTDIR}/bin/llvm-as \
        NM=${CLANG_ROOTDIR}/bin/llvm-nm \
        OBJCOPY=${CLANG_ROOTDIR}/bin/llvm-objcopy \
        OBJDUMP=${CLANG_ROOTDIR}/bin/llvm-objdump \
        STRIP=${CLANG_ROOTDIR}/bin/llvm-strip \
        LLVM=1 \
        LLVM_IAS=1 \
        CROSS_COMPILE=${CLANG_ROOTDIR}/bin/aarch64-linux-gnu- \
        CROSS_COMPILE_ARM32=${CLANG_ROOTDIR}/bin/arm-linux-gnueabi- 2>&1 | tee error.log
fi

End=$(date +"%s")
Diff=$(($End - $Start))
}

make O=out ARCH=arm64 daisy_defconfig
build_kernel

##------------------------------------------------------##

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

##------------------------------------------------------##

# Get MD5SUM and SHASUM of the zipped kernel
Hash() {
    SHA=$(shasum "$(pwd)"/AnyKernel3/Panda-r"${RELEASE}"-"${BUILD_TIME}".zip | cut -f 1 -d '/')
    MD5=$(md5sum "$(pwd)"/AnyKernel3/Panda-r"${RELEASE}"-"${BUILD_TIME}".zip | cut -f 1 -d '/')
}

##------------------------------------------------------##

msg $green "|| Zipping into a flashable zip ||" $white
FILE="$(pwd)/out/arch/arm64/boot/Image.gz-dtb"
if [ -f "$FILE" ]; then
    zip_kernelimage
    Hash
    echo -e "$green << Build completed in in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds >> \n $white"
    echo "The kernel has successfully been compiled and can be found in $(pwd)/AnyKernel3/Panda-r${RELEASE}-${BUILD_TIME}.zip"
    echo -e "$yellow  MD5 Checksum : $MD5 $white"
    echo -e "$yellow SHA1 Checksum : $SHA $white"
    rm -rf error.log
    read -r -p "Press enter to continue"
    else
    echo -e "$red << Failed to compile the kernel in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds >> \n $white"
    echo -e "$red << Check up to find the error >> $white"
    read -r -p "Press enter to continue"
fi
msg $green "|| Enjoy! ^^ ||" $white

##------------------------------------------------------##