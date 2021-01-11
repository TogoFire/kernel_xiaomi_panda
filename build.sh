#!/usr/bin/env bash

# Android Kernel Build Script

# Setup colour for the script
blue='\033[0;34m'
yellow='\033[0;33m'
white='\033[0m'
red='\033[0;31m'
green='\e[0;32m'
light_purple='\033[1;35m'
cyan='\033[0;36m'
purple='\033[0;35m'
pink='\033[38;5;206m'
orange_yellow='\033[38;5;214m'
greenish_yellow='\033[38;5;190m'

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

# Get Linux distro and version
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
else
    OS=$(uname -s)
    VER=$(uname -r)
fi

echo $OS $VER

##------------------------------------------------------##

# Check if is Legendary!
if [[ "$OS" == *"Tumbleweed"* ]]; then
    echo -e "${light_purple} << You are LEGENDARY! >> ${white}"
fi

##------------------------------------------------------##

# Check if a good linux is being used
if [[ "$OS" == *"SUSE"* ]] || [[ "$OS" == *"Regata"* ]] || [[ "$OS" == *"Fedora"* ]] || [[ "$OS" == *"Nobara"* ]] || [[ "$OS" == *"Ultramarine"* ]] || [[ "$OS" == *"Rocky"* ]]; then
    echo -e "${cyan} << Congratulations! You are using a decent Linux >> ${white}"
else
    echo -e "${red} << Danger detected! You are using MEME linux. Get out of this garbage as soon as possible >> ${white}"
fi

##------------------------------------------------------##

# Setup the build environment if OS is openSUSE
AKHILNARANG="environment"
msg $green "|| Clone & Build environment ||" $white
if [[ "$OS" == *"SUSE"* ]] || [[ "$OS" == *"Regata"* ]]; then
    echo -e "${blue} << Environment to openSUSE >> ${white}"
  # Check if $DIR exists or not
  if [[ ! -d "$AKHILNARANG" ]]; then
      echo -e "$yellow $AKHILNARANG not found, downloading... $white"
      git clone --depth=1 https://github.com/TogoFire/scripts ${AKHILNARANG}
      cd "${AKHILNARANG}" && bash setup/opensuse.sh
      cd ..
  else
      echo -e "$yellow $AKHILNARANG found, skipping step $white"
  fi
fi

# Setup the build environment if OS is Fedora
if [[ "$OS" == *"Fedora"* ]] || [[ "$OS" == *"Nobara"* ]] || [[ "$OS" == *"Ultramarine"* ]] || [[ "$OS" == *"Rocky"* ]]; then
    echo -e "${blue} << Environment to Fedora >> ${white}"
  # Check if $DIR exists or not
  if [[ ! -d "$AKHILNARANG" ]]; then
      echo -e "$yellow $AKHILNARANG not found, downloading... $white"
      git clone --depth=1 https://github.com/TogoFire/scripts ${AKHILNARANG}
      cd "${AKHILNARANG}" && bash setup/fedora.sh
      cd ..
  else
      echo -e "$yellow $AKHILNARANG found, skipping step $white"
  fi
fi

# Setup the build environment if OS is Arch
if [[ "$OS" == *"Arch"* ]] || [[ "$OS" == *"Manjaro"* ]] || [[ "$OS" == *"Endeavour"* ]] || [[ "$OS" == *"Garuda"* ]]; then
    echo -e "${blue} << Environment to Arch >> ${white}"
  # Check if $DIR exists or not
  if [[ ! -d "$AKHILNARANG" ]]; then
      echo -e "$yellow $AKHILNARANG not found, downloading... $white"
      git clone --depth=1 https://github.com/akhilnarang/scripts ${AKHILNARANG}
      cd "${AKHILNARANG}" && bash setup/arch-manjaro.sh
      cd ..
  else
      echo -e "$yellow $AKHILNARANG found, skipping step $white"
  fi
fi

# Setup the build environment if OS is MEME
if [[ "$OS" == *"Ubuntu"* ]] || [[ "$OS" == *"Mint"* ]] || [[ "$OS" == *"Debian"* ]] || [[ "$OS" == *"Pop"* ]] || [[ "$OS" == *"Zorin"* ]] || [[ "$OS" == *"Elementary"* ]] || [[ "$OS" == *"Mx"* ]] || [[ "$OS" == *"antiX"* ]] || [[ "$OS" == *"Sparky"* ]] || [[ "$OS" == *"Parrot"* ]] || [[ "$OS" == *"Deepin"* ]] || [[ "$OS" == *"Kali"* ]] || [[ "$OS" == *"KDE"* ]] || [[ "$OS" == *"Lite"* ]]; then
    echo -e "${pink} << Environment to MEME Linux >> ${white}"
  # Check if $DIR exists or not
  if [[ ! -d "$AKHILNARANG" ]]; then
      echo -e "$yellow $AKHILNARANG not found, downloading... $white"
      git clone --depth=1 https://github.com/akhilnarang/scripts ${AKHILNARANG}
      cd "${AKHILNARANG}" && bash setup/android_build_env.sh
      cd ..
  else
      echo -e "$yellow $AKHILNARANG found, skipping step $white"
  fi
fi

##------------------------------------------------------##

# Clone clang if RPM & Arch Linux
msg $green "|| Cloning Clang ||" $white
if [[ "$OS" == *"SUSE"* ]] || [[ "$OS" == *"Regata"* ]] || [[ "$OS" == *"Fedora"* ]] || [[ "$OS" == *"Nobara"* ]] || [[ "$OS" == *"Ultramarine"* ]] || [[ "$OS" == *"Rocky"* ]] || [[ "$OS" == *"Arch"* ]] || [[ "$OS" == *"Manjaro"* ]] || [[ "$OS" == *"Endeavour"* ]] || [[ "$OS" == *"Garuda"* ]]; then
    CLANG_VERSION="clang-neutron"
    echo -e "$blue << Clang to RPM & Arch Linux >> $white"
    if [[ ! -d "$CLANG_VERSION" ]]; then
        echo -e "$yellow $CLANG_VERSION not found, downloading... $white"
        mkdir "${CLANG_VERSION}"
        cd "${CLANG_VERSION}"
        bash <(curl -s "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman") -S
        cd ..
    else
        echo -e "$yellow $CLANG_VERSION found, checking updates & skip step $white"
        cd "${CLANG_VERSION}"
        bash <(curl -s "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman") -U
        bash <(curl -s "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman") -I
        cd ..
    fi
fi

# Clone clang if MEME Linux
if [[ "$OS" == *"Ubuntu"* ]] || [[ "$OS" == *"Mint"* ]] || [[ "$OS" == *"Debian"* ]] || [[ "$OS" == *"Pop"* ]] || [[ "$OS" == *"Zorin"* ]] || [[ "$OS" == *"Elementary"* ]] || [[ "$OS" == *"Mx"* ]] || [[ "$OS" == *"antiX"* ]] || [[ "$OS" == *"Sparky"* ]] || [[ "$OS" == *"Parrot"* ]] || [[ "$OS" == *"Deepin"* ]] || [[ "$OS" == *"Kali"* ]] || [[ "$OS" == *"KDE"* ]] || [[ "$OS" == *"Lite"* ]]; then
    CLANG_VERSION="clang-playground"
    echo -e "$pink << Clang to MEME Linux >> $white"
    if [[ ! -d "$CLANG_VERSION" ]]; then
        echo -e "$yellow $CLANG_VERSION not found, downloading... $white"
        git clone --depth=1 https://gitlab.com/PixelOS-Devices/playgroundtc.git ${CLANG_VERSION} --depth=1 --no-tags --single-branch
    else
        echo -e "$yellow $CLANG_VERSION found, skip step $white"
    fi
fi

##------------------------------------------------------##

# Clone AnyKernel3
ANYKERNEL3_VERSION="AnyKernel3"
msg $green "|| Cloning AnyKernel3 ||" $white
if [[ ! -d "$ANYKERNEL3_VERSION" ]]; then
    echo -e "$yellow $ANYKERNEL3_VERSION not found, downloading... $white"
    git clone --depth=1 https://github.com/TogoFire/AnyKernel3 -b panda "${ANYKERNEL3_VERSION}"
else
    echo -e "$yellow $ANYKERNEL3_VERSION found, skipping step $white"
fi

##------------------------------------------------------##

# Clean up
echo -e "${orange_yellow} Clean up ${white}"
rm -rf out/*
rm -rf error.log
rm -rf changelog/*

##------------------------------------------------------##

# Create a filename for our changelog in a changelog directory
CHANGELOG_DIR="changelog"
CHANGELOG_FILE="$CHANGELOG_DIR/kernel-changelog.txt"

# Check if the changelog directory exists, and create it if it doesn't
if [ ! -d "$CHANGELOG_DIR" ]; then
  mkdir "$CHANGELOG_DIR"
fi

# Use git log to get the most recent kernel commits
git log -n 350 --pretty=format:"%h - %s (%an)" > $CHANGELOG_FILE

# Print the location of the changelog file
echo -e "${purple} Changelog saved to $CHANGELOG_FILE ${white}"

# Add commit names to the changelog file
sed -i -e "s/^/- /" $CHANGELOG_FILE

##------------------------------------------------------##

# Calculate how long compiling compiling the kernel took
BUILD_START=$(date +"%s")
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))

##------------------------------------------------------##

# Compile the kernel
msg $greenish_yellow "|| 🔨 Started Compilation ||" $white
CLANG_ROOTDIR="$(pwd)/${CLANG_VERSION}"
TOOLCHAIN="clang"

build_kernel() {
Start=$(date +"%s")

if [ "$TOOLCHAIN" == ${TOOLCHAIN} ]; then

make -j$(nproc) ARCH=arm64 SUBARCH=arm64 O=out \
    CC="${CLANG_ROOTDIR}/bin/clang" \
    LD="${CLANG_ROOTDIR}/bin/ld.lld" \
    AR="${CLANG_ROOTDIR}/bin/llvm-ar" \
    AS="${CLANG_ROOTDIR}/bin/llvm-as" \
    NM="${CLANG_ROOTDIR}/bin/llvm-nm" \
    OBJCOPY="${CLANG_ROOTDIR}/bin/llvm-objcopy" \
    OBJDUMP="${CLANG_ROOTDIR}/bin/llvm-objdump" \
    STRIP="${CLANG_ROOTDIR}/bin/llvm-strip" \
    LLVM=1 \
    LLVM_IAS=1 \
    CROSS_COMPILE="${CLANG_ROOTDIR}/bin/aarch64-linux-gnu-" \
    CROSS_COMPILE_ARM32="${CLANG_ROOTDIR}/bin/arm-linux-gnueabi-" 2>&1 | tee error.log
fi

End=$(date +"%s")
Diff=$(($End - $Start))
}

make O=out ARCH=arm64 daisy_defconfig
build_kernel

##------------------------------------------------------##

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
    echo -e "$green << Build completed in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds >> \n $white"
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

