ARG WAYLAND_BASE_IMAGE=balenalib/aarch64-ubuntu:lunar-run

# Build weston
FROM balenalib/aarch64-ubuntu:lunar-build as weston-builder

ENV DEBIAN_FRONTEND noninteractive
RUN echo "deb https://repo.download.nvidia.com/jetson/common r35.4 main" >  /etc/apt/sources.list.d/nvidia.list \
       && echo "deb https://repo.download.nvidia.com/jetson/t234 r35.4 main" >>  /etc/apt/sources.list.d/nvidia.list \
       && apt-key adv --fetch-key http://repo.download.nvidia.com/jetson/jetson-ota-public.asc \
       && mkdir -p /opt/nvidia/l4t-packages/ && touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall


# Build tools
RUN apt-get update && apt-get install -y \
    cmake \
    ninja-build \
    python3-pip

# Weston build dependencies
RUN apt update && apt install -y \
    libxkbcommon-dev \
    libwayland-dev \
    libinput-dev \
    libdrm2 \
    libdrm-dev \
    wayland-protocols \
    libegl-dev \
    libpam0g-dev \
    libseat-dev \
    libgles2-mesa-dev \
    libpango1.0-dev \
    libpangocairo-1.0-0 \
    libgbm-dev \
    libpipewire-0.3-dev \
    freerdp2-dev \
    libx11-xcb-dev \
    xwayland \
    libxcb-composite0-dev \
    libxcursor-dev \
    libsystemd-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libxcb-cursor-dev \
    libxcb-xkb-dev \
    libkqueue-dev \
    libva-dev

# display-info sub-project deps
RUN apt update && apt install -y \
    hwdata \
    edid-decode

# neatvnc sub-project deps
RUN apt update && apt install -y \
    libturbojpeg0-dev \
    libgnutls28-dev \
    libavcodec-dev \
    libavfilter-dev \
    libavutil-dev

RUN apt update && apt install -y \
    libnvidia-egl-wayland-dev

ENV LD_LIBRARY_PATH /usr/lib/aarch64-linux-gnu/tegra:${LD_LIBRARY_PATH}
RUN ldconfig

# For docs
# RUN apt update && apt install -y doxygen python3-sphinx python3-breathe && pip3 install graphviz

RUN pip3 install meson --break-system-packages

WORKDIR /src

ENV DEBIAN_FRONTEND noninteractive
ENV WESTON_VERSION=12.0

RUN mkdir -p /opt/weston && \
    git clone https://gitlab.freedesktop.org/wayland/weston.git && \
    cd weston && \
    git checkout ${WESTON_VERSION} && \
    meson setup build/ --prefix=/opt/weston && \
    ninja -C build/ install && \
    cd ..


# Import built weston into wayland base
FROM ${WAYLAND_BASE_IMAGE} as runtime

ENV DEBIAN_FRONTEND noninteractive

# Add jammy repos because some nvidia stuff is outdated
RUN echo "deb http://ports.ubuntu.com/ubuntu-ports/ jammy main restricted" >> /etc/apt/sources.list \
    && echo "deb http://ports.ubuntu.com/ubuntu-ports/ jammy-updates main restricted"  >> /etc/apt/sources.list\
    && echo "deb http://ports.ubuntu.com/ubuntu-ports/ jammy universe"  >> /etc/apt/sources.list\
    && echo "deb http://ports.ubuntu.com/ubuntu-ports/ jammy multiverse"  >> /etc/apt/sources.list\
    && echo "deb http://ports.ubuntu.com/ubuntu-ports/ jammy-updates multiverse"  >> /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive
RUN echo "deb https://repo.download.nvidia.com/jetson/common r35.4 main" >  /etc/apt/sources.list.d/nvidia.list \
       && echo "deb https://repo.download.nvidia.com/jetson/t234 r35.4 main" >>  /etc/apt/sources.list.d/nvidia.list \
       && apt-key adv --fetch-key http://repo.download.nvidia.com/jetson/jetson-ota-public.asc \
       && mkdir -p /opt/nvidia/l4t-packages/ && touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall

# RUN \
#     apt-get update && apt-get install -y wget tar lbzip2 binutils xz-utils zstd && \
#     cd /tmp/ && wget https://developer.nvidia.com/downloads/embedded/l4t/r35_release_v4.1/release/jetson_linux_r35.4.1_aarch64.tbz2 && \
#     tar xf jetson_linux_r35.4.1_aarch64.tbz2 && \
#     cd Linux_for_Tegra && \
#     sed -i 's/config.tbz2\"/config.tbz2\" --exclude=etc\/hosts --exclude=etc\/hostname/g' apply_binaries.sh && \
#     sed -i 's/install --owner=root --group=root \"${QEMU_BIN}\" \"${L4T_ROOTFS_DIR}\/usr\/bin\/\"/#install --owner=root --group=root \"${QEMU_BIN}\" \"${L4T_ROOTFS_DIR}\/usr\/bin\/\"/g' nv_tegra/nv-apply-debs.sh && \
#     sed -i 's/chroot . \//  /g' nv_tegra/nv-apply-debs.sh && \
#     ./apply_binaries.sh -r / --target-overlay && cd .. && \
#     rm -rf Linux_for_Tegra && \
#     echo "/usr/lib/aarch64-linux-gnu/tegra" > /etc/ld.so.conf.d/nvidia-tegra.conf 

# Weston run dependencies
RUN apt update && apt install -o DPkg::Options::="--force-confnew" -y --no-install-recommends \
    libaml0 \
    libc6 \
    libc6 \
    libcairo2 \
    libdrm2 \
    libegl1 \
    libfontconfig1 \
    libfreerdp-server2-2 \
    libfreerdp2-2 \
    libgbm1 \
    libgles2 \
    libglib2.0-0 \
    libgstreamer-plugins-base1.0-0 \
    libgstreamer1.0-0 \
    libinput10 \
    libjpeg8 \
    liblcms2-2 \
    libneatvnc0 \
    libpam0g \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libpipewire-0.3-0 \
    libpixman-1-0 \
    libpng16-16 \
    libseat1 \
    libudev1 \
    libva-drm2 \
    libva2 \
    libwayland-client0 \
    libwayland-cursor0 \
    libwayland-egl1 \
    libwayland-server0 \
    libwebp7 \
    libwinpr2-2 \
    libx11-6 \
    libx11-xcb1 \
    libxcb-composite0 \
    libxcb-render0 \
    libxcb-shm0 \
    libxcb-xfixes0 \
    libxcb-xkb1 \
    libxcb1 \
    libxcursor1 \
    libxkbcommon0 \
    xwayland \
    && rm -rf /var/lib/apt/lists/* 
    
# Nvidia drm/kms libs
RUN apt-get update && apt-get install -o DPkg::Options::="--force-confnew" -y \
        nvidia-l4t-gbm \
        nvidia-l4t-wayland \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y kmod \
    && rm -rf /var/lib/apt/lists/*

COPY --from=weston-builder /opt/weston/ /opt/weston
COPY weston.ini /etc/xdg/weston/weston.ini

ENV XDG_RUNTIME_DIR /run/weston
ENV XDG_CONFIG_HOME /etc/xdg/weston
ENV WLD=/opt/weston/
ENV LD_LIBRARY_PATH ${WLD}/lib:${WLD}/lib/aarch64-linux-gnu:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/usr/lib/aarch64-linux-gnu/tegra-egl
ENV PKG_CONFIG_PATH ${WLD}/lib/pkgconfig/:${WLD}/share/pkgconfig/:${PKG_CONFIG_PATH}
ENV PATH=${WLD}/bin:$PATH

RUN ldconfig

RUN mkdir -p /tmp/.X11-unix && mkdir -p /run/weston
COPY start_weston.sh /opt/weston/start_weston.sh
RUN chmod +x /opt/weston/start_weston.sh

ENV UDEV=1

CMD ["/bin/bash", "/opt/weston/start_weston.sh"]
