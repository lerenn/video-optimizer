#!/usr/bin/env bash

# Shamefully copied from https://gist.github.com/rosstimson/05a697008faa0f87524b
# Thanks to rosstimson (https://gist.github.com/rosstimson)

# Build ffmpeg with pretty much support for everything as per:
# https://trac.ffmpeg.org/wiki/CompilationGuide/Centos
# includes codecs with weird licensing like MP3 and AAC.
#
# Tested on Ubuntu 20.04

# Install build requirements.
sudo apt install -y \
      autoconf \
      automake \
      cmake \
      cmake-curses-gui \
      libfreetype-dev \
      libnuma-dev \
      gcc \
      g++ \
      git \
      libogg-dev \
      libtool \
      libvorbis-dev \
      libvpx-dev \
      make \
      mercurial \
      nasm \
      libopus-dev \
      pkg-config \
      yasm \
      zlib1g-dev

bash common.sh
