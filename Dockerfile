FROM ubuntu:22.04

# 基础依赖
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    checkinstall \
    pkg-config \
    libusb-1.0-0-dev \
    usbmuxd \
    libusbmuxd-dev \
    libssl-dev \
    autoconf \
    automake \
    libtool \
    make \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# 构建并安装 libplist
RUN git clone https://github.com/libimobiledevice/libplist.git \
    && cd libplist \
    && ./autogen.sh --prefix=/usr --without-cython \
    && make \
    && make install \
    && ldconfig

# 构建并安装 libimobiledevice
RUN git clone https://github.com/libimobiledevice/libimobiledevice.git \
    && cd libimobiledevice \
    && ./autogen.sh --prefix=/usr \
    && make \
    && make install \
    && ldconfig

VOLUME ["/pairing"]
WORKDIR /pairing

ENTRYPOINT ["bash", "-c", "idevicepair pair && idevicepair validate && idevicepair save /pairing/device_pair.plist && echo 'Pairing file saved to /pairing/device_pair.plist' && tail -f /dev/null"]
