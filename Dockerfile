FROM debian:stable-slim

RUN apt-get update && apt-get install -y \
    usbmuxd \
    libimobiledevice6.0 \
    libimobiledevice-utils \
    && rm -rf /var/lib/apt/lists/*

# 挂载目录保存 pairing 文件
VOLUME ["/pairing"]

WORKDIR /pairing

ENTRYPOINT ["bash", "-c", "idevicepair pair && idevicepair validate && idevicepair save /pairing/device_pair.plist && echo 'Pairing file saved to /pairing/device_pair.plist' && tail -f /dev/null"]
