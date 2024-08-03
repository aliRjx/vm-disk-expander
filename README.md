# Disk Resize Script

This script helps to resize the disk of an Ubuntu Server running in a VMware environment. It automates the process of resizing the partition, physical volume, logical volume, and the filesystem.

## Prerequisites

- Ensure you have expanded the disk size in VMware.
- This script must be run as root or with sudo privileges.

## Instructions

1. **Expand the Virtual Disk Size in VMware**

   - Shut down the VM.
   - Open VMware Workstation or Player.
   - Select your Ubuntu Server VM.
   - Click on `Edit virtual machine settings`.
   - Select the `Hard Disk` (SCSI) option.
   - Click on the `Utilities` dropdown or button.
   - Select `Expand`, then enter the new size for the disk.
   - Confirm and apply the changes.
   - Boot the VM.

2. **Run the Script**

   - Copy the `resize_disk.sh` script to your server.
   - Make the script executable:
     ```bash
     chmod +x resize_disk.sh
     ```
   - Run the script:
     ```bash
     sudo ./resize_disk.sh
     ```

3. **Provide Disk and Partition Information**

   - When prompted, enter the disk (e.g., `/dev/sda`) and the partition (e.g., `/dev/sda3`) manually.

## What the Script Does

1. **Installs Necessary Tools**

   - Installs `parted` for partition resizing.
   - Installs `cloud-guest-utils` which includes `growpart`.

2. **Resizes the Partition**

   - Uses `parted` to resize the specified partition to use all available space.

3. **Resizes the Physical Volume**

   - Uses `pvresize` to resize the physical volume to encompass the resized partition.

4. **Extends the Logical Volume**

   - Identifies the logical volume path.
   - Uses `lvextend` to extend the logical volume to use all available free space.

5. **Resizes the Filesystem**

   - Uses `resize2fs` to resize the filesystem to occupy the extended logical volume.

6. **Displays the Final Disk Space**

   - Runs `df -h` to display the new disk space.

## Notes

- Ensure you have a backup of your data before running disk operations.
- The script assumes the root filesystem is using LVM and `ext4`. Adjust accordingly if your setup differs.
