#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Provide the disk and partition manually
read -p "Enter the disk (e.g., /dev/sda): " DISK
read -p "Enter the partition (e.g., /dev/sda3): " PARTITION

# Confirm the disk and partition details
echo "Disk identified: $DISK"
echo "Partition identified: $PARTITION"

# Install necessary tools
apt update
apt install -y parted cloud-guest-utils

# Resize the partition using parted
echo "Resizing the partition..."
parted $DISK --script resizepart ${PARTITION##*[a-z]} 100%

# Resize the physical volume
echo "Resizing the physical volume..."
pvresize $PARTITION

# Extend the logical volume
LV_PATH=$(lvdisplay | grep "LV Path" | awk '{print $3}')
echo "Extending the logical volume..."
lvextend -l +100%FREE $LV_PATH

# Resize the filesystem
echo "Resizing the filesystem..."
resize2fs $LV_PATH

# Display the final disk space
echo "Displaying the final disk space..."
df -h
