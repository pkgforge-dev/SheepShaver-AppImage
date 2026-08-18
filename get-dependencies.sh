#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    libdecor \
    sdl3     \
    vde2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Building SheepShaver..."
echo "---------------------------------------------------------------"
REPO="https://github.com/kanjitalk755/macemu"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./macemu
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./macemu/SheepShaver/src/Unix
NO_CONFIGURE=1 ./autogen.sh
./configure \
    --with-sdl3 \
    --enable-sdl-video \
    --enable-sdl-audio \
    --enable-jit-compiler \
    --enable-addressing=direct,0x10000000 \
    --with-bincue \
    --with-libvhd \
    --with-vdeplug

make -j$(nproc)
mv -v ./SheepShaver ../../../../AppDir/bin
