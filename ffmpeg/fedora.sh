#!/usr/bin/env bash

# Shamefully copied from https://gist.github.com/rosstimson/05a697008faa0f87524b
# Thanks to rosstimson (https://gist.github.com/rosstimson)

# Build ffmpeg with pretty much support for everything as per:
# https://trac.ffmpeg.org/wiki/CompilationGuide/Centos
# includes codecs with weird licensing like MP3 and AAC.
#
# Tested on Fedora 30.

# Get actual directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Install build requirements.
sudo yum install -y \
      autoconf \
      automake \
      cmake \
      freetype-devel \
      gcc \
      gcc-c++ \
      git \
      libogg-devel \
      libtool \
      libvorbis-devel \
      libvpx-devel \
      make \
      mercurial \
      nasm \
      opus-devel \
      pkgconfig \
      yasm \
      zlib-devel

bash ${DIR}/common.sh
