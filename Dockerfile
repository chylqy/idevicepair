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
    libcurl4-openssl-dev \
    autoconf \
    automake \
    libtool \
    make \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# 构建并安装 libplist (安装到 /usr/local)
RUN git clone https://github.com/libimobiledevice/libplist.git \
    && cd libplist \
    && ./autogen.sh --prefix=/usr/local --without-cython \
    && make \
    && make install \
    && ldconfig

# 构建并安装 libimobiledevice-glue
RUN git clone https://github.com/libimobiledevice/libimobiledevice-glue.git \
    && cd libimobiledevice-glue \
    && ./autogen.sh --prefix=/usr/local \
    && make \
    && make install \
    && ldconfig
    
# 构建并安装 libtatsu
RUN git clone https://github.com/libimobiledevice/libtatsu.git \
    && cd libtatsu \
    && ./autogen.sh --prefix=/usr/local \
    && make \
    && make install \
    && ldconfig

# 构建并安装 libimobiledevice (强制使用 /usr/local 的 libplist)
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib/x86_64-linux-gnu/pkgconfig
RUN git clone https://github.com/libimobiledevice/libimobiledevice.git \
    && cd libimobiledevice \
    && ./autogen.sh --prefix=/usr/local \
    && make \
    && make install \
    && ldconfig

VOLUME ["/pairing"]
WORKDIR /pairing

ENTRYPOINT ["bash", "-c", "idevicepair pair && idevicepair validate && idevicepair save /pairing/device_pair.plist && echo 'Pairing file saved to /pairing/device_pair.plist' && tail -f /dev/null"]
