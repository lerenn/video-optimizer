FROM fedora

# Install minimal requirements
RUN yum install -y sudo

# Create a directory for files
RUN mkdir -p /docker

# Copy installation files
COPY ffmpeg/ /docker/ffmpeg

# Run ffmep installation
RUN bash /docker/ffmpeg/fedora.sh && \
    rm -rf /docker/ffmpeg/build && \
    yum remove -y autoconf automake cmake freetype-devel gcc gcc-c++ git \
    libogg-devel libtool libvorbis-devel libvpx-devel make mercurial nasm \
    opus-devel pkgconfig yasm zlib-devel && \
    yum clean all

# Create a volume for data
VOLUME /data