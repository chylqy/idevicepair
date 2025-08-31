FROM ubuntu:22.04

# 安装构建依赖
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    checkinstall \
    pkg-config \
    libusb-1.0-0-dev \
    libplist-dev \
    usbmuxd \
    libusbmuxd-dev \
    libssl-dev \
    libtoolize \
    aclocal \
    autoheader \
    automake \
    autoconf \
    && rm -rf /var/lib/apt/lists/*

# 编译安装 libimobiledevice
RUN git clone https://github.com/libimobiledevice/libimobiledevice.git \
    && cd libimobiledevice \
    && ./autogen.sh \
    && make \
    && make install \
    && ldconfig

VOLUME ["/pairing"]
WORKDIR /pairing

ENTRYPOINT ["bash", "-c", "idevicepair pair && idevicepair validate && idevicepair save /pairing/device_pair.plist && echo 'Pairing file saved to /pairing/device_pair.plist' && tail -f /dev/null"]
