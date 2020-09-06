#!/usr/bin/env bash

# Shamefully copied from https://gist.github.com/rosstimson/05a697008faa0f87524b
# Thanks to rosstimson (https://gist.github.com/rosstimson)

# Build ffmpeg with pretty much support for everything as per:
# https://trac.ffmpeg.org/wiki/CompilationGuide/Centos
# includes codecs with weird licensing like MP3 and AAC.
#
# Tested on Fedora 30.

# Set variables
WORK_DIR="${PWD}/build"

# Set
set -eux

# libx264
mkdir -p ${WORK_DIR} && cd ${WORK_DIR}
if [ ! -d "${WORK_DIR}/x264" ]; then
      git clone https://code.videolan.org/videolan/x264.git
fi
cd x264
./configure --prefix="/usr/local" --enable-static
make -j $(nproc)
sudo make install

# libx265
mkdir -p ${WORK_DIR} && cd ${WORK_DIR}
if [ ! -d "${WORK_DIR}/x265" ]; then
      git clone https://bitbucket.org/multicoreware/x265_git x265
fi
mkdir -p ${WORK_DIR} && cd ${WORK_DIR}/x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="/usr/local" -DENABLE_SHARED:bool=off ../../source 
make -j $(nproc)
sudo make install

# libfdk_aac
mkdir -p ${WORK_DIR} && cd ${WORK_DIR}
if [ ! -d "${WORK_DIR}/fdk-aac" ]; then
      git clone git://git.code.sf.net/p/opencore-amr/fdk-aac
fi
cd fdk-aac
autoreconf -fiv
./configure --prefix="/usr/local" --disable-shared
make -j $(nproc)
sudo make install

# libmp3lame
mkdir -p ${WORK_DIR} && cd ${WORK_DIR}
if [ ! -d "${WORK_DIR}/lame-3.99.5" ]; then
      curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
      tar xzvf lame-3.99.5.tar.gz
fi
cd lame-3.99.5
./configure --prefix="/usr/local" --disable-shared --enable-nasm
make -j $(nproc)
sudo make install

# ffmpeg
mkdir -p ${WORK_DIR} && cd ${WORK_DIR}
if [ ! -d "${WORK_DIR}/ffmpeg" ]; then
      git clone git://source.ffmpeg.org/ffmpeg
fi
cd ffmpeg
PKG_CONFIG_PATH="/usr/local/lib/pkgconfig" ./configure --extra-libs=-lpthread --prefix="/usr/local" --extra-cflags="-I/usr/local/include" --extra-ldflags="-L/usr/local/lib" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libfdk-aac --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265
make -j $(nproc)
sudo make install
hash -r

