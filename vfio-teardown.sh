#!/bin/bash

DATE=$(date + "%m/%d/%Y %R:%S :")
echo "$DATE Beginning of Teardown"

# Unload VFIO-PCI driver
modprobe -r vfio
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1

# Rebind GPU to NVIDIA driver
virsh nodedev-reattach pci_0000_01_00_0
virsh nodedev-reattach pci_0000_01_00_1

# Load NVIDIA drivers
echo "$DATE Loading NVIDIA GPU Drivers"
modprobe nvidia_drm
modprobe nvidia_uvm
modprobe nvidia_modeset
modprobe drm_kms_helper
modprobe nvidia
modprobe i2c_nvidia_gpu
modprobe drm
echo "$DATE Loaded NVIDIA GPU Drivers"

sleep "1"

# Rebind EFI-Framebuffer
echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

# Rebind VT consoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 1 > /sys/class/vtconsole/vtcon1/bind

# Restart display manager
systemctl start display-manager

# nvidia-xconfig --query-gpu-info > /dev/null 2>&1

echo "$DATE End of Teardown"
