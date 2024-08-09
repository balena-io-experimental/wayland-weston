#!/bin/bash

if lsmod | grep -q drm; then
    echo "nvidia-drm already loaded, removing"
    rmmod nvidia_drm
fi

modprobe nvidia-drm modeset=1
echo "loaded nvidia-drm with modeset=1"
chmod 700 /run/weston
weston --idle-time=0
