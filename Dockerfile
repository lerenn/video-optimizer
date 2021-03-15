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
    yum clean all

# Create a volume for data
VOLUME /data

# Copy scripts
COPY scripts/* /usr/bin

# Set environment variables
ENV LD_LIBRARY_PATH /usr/local/lib:/usr/local/lib64