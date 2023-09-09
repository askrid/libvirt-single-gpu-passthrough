#!/bin/bash

DATE=$(date + "%m/%d/%Y %R:%S :")
echo "$DATE Beginning of Startup"

# Stop display manager
systemctl stop display-manager

# Unbind VT Consoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# Unbind EFI-Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

sleep "1"

# Unload NVIDIA GPU drivers
echo "$DATE Unloading NVIDIA GPU Drivers"
modprobe -r nvidia_drm
modprobe -r nvidia_uvm
modprobe -r nvidia_modeset
modprobe -r drm_kms_helper
modprobe -r nvidia
modprobe -r ic2_nvidia_gpu
modprobe -r drm
echo "$DATE Unloaded NVIDIA GPU Drivers"

# Unbind GPU from display driver
virsh nodedev-detach pci_0000_01_00_0
virsh nodedev-detach pci_0000_01_00_1

# Load VFIO-PCI driver
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1

echo "$DATE End of Startup"
