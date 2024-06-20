# syntax=docker/dockerfile:1
FROM ubuntu:22.04

# Install app dependencies
RUN apt update && \
    apt install -y --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    g++ \
    gcc \
    git \
    libgl1-mesa-dev \
    libtool \
    libudev-dev \
    libx11-dev \
    libxcursor-dev \
    libxi-dev \
    libxrandr-dev \
    make \
    ninja-build \
    pkg-config \
    python-is-python3 \
    python3 \
    python3-pip \
    sudo \
    tar \
    unzip \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Create special directory for all sources
RUN mkdir /home/workspace
WORKDIR /home/workspace

# Bootstrap VCPKG and install all Planszowker's dependencies
RUN git clone -b "#13-Kingdomino_game_adaptation" --recurse-submodules -j8 https://github.com/Planszowker/Planszowker.git
WORKDIR /home/workspace/Planszowker
RUN ./vcpkg/bootstrap-vcpkg.sh
RUN export VCPKG_FORCE_SYSTEM_BINARIES=1
RUN export VCPKG_DEFAULT_HOST_TRIPLET=arm64-linux
RUN ./vcpkg/vcpkg install

# Configure CMake and build Planszówker
RUN cmake -B ../build -S . --preset=default -DCMAKE_TOOLCHAIN_FILE=vcpkg/scripts/buildsystems/vcpkg.cmake \
    && cmake --build ../build
