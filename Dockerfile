FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG FLUTTER_VERSION=3.29.3

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV FLUTTER_ROOT=/opt/flutter
ENV PATH=/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}

RUN apt-get update && apt-get install -y \
    bash \
    ca-certificates \
    clang \
    cmake \
    curl \
    file \
    git \
    libgtk-3-dev \
    libglu1-mesa \
    libssl-dev \
    ninja-build \
    openjdk-17-jdk \
    pkg-config \
    unzip \
    xz-utils \
    zip \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt \
    && curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    | tar -xJ -C /opt

RUN git config --global --add safe.directory /opt/flutter \
    && git config --global --add safe.directory /workspace \
    && flutter config --no-analytics \
    && flutter config --enable-linux-desktop \
    && flutter precache --linux

WORKDIR /workspace

CMD ["flutter", "build", "linux"]