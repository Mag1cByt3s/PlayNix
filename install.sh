#!/usr/bin/env bash

# For installing NixOS having booted from the minimal USB image.
# To run:
#     bash -c "$(curl https://raw.githubusercontent.com/Mag1cByt3s/PlayNix/main/install.sh)"

# e: Exit script immediately if any command returns a non-zero exit status.
# u: Exit script immediately if an undefined variable is used.
# o pipefail: Ensure Bash pipelines return a non-zero status if any command fails.
set -eou pipefail

# make sure this script is run as root (sudo does not work)
if [ "$(id -u)" -ne 0 ]; then
    printf "This script has to run as root (do not use sudo)\n" >&2
    exit 1
elif [ -n "${SUDO_USER:-}" ]; then
    printf "This script has to run as root (not sudo)\n" >&2
    exit 1
fi

# define variables
LOGFILE="/mnt/nixos_install.log"
FLAKE="github:Mag1cByt3s/PlayNix"
GIT_REV="main"

# define colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[37m"
ENDCOLOR="\e[0m"

function colorprint() {
    local color="$1"
    local text="$2"
    local endcolor="\e[0m"
    echo -e "${color}${text}${endcolor}"
}

function log() {
    local level="$1"
    local message="$2"

    case "$level" in
        "ERROR")
            colorprint "$RED" "[$level] $message"
            ;;
        "INFO")
            colorprint "$BLUE" "[$level] $message"
            ;;
        "WARN")
            colorprint "$YELLOW" "[$level] $message"
            ;;
        *)
            echo "[$level] $message"
            ;;
    esac
}

function check_command() {
    local cmd="$1"
    if ! command -v "$cmd" &> /dev/null; then
        log "ERROR" "Command not found: $cmd. Please install it and re-run the script."
        exit 1
    fi
}

function yesno() {
    local prompt="$1"
    while true; do
        read -rp "$prompt [y/n] " yn
        case $yn in
            [Yy]* ) echo "y"; return;;
            [Nn]* ) echo "n"; return;;
            * ) log "INFO" "Please answer yes or no.";;
        esac
    done
}

log "INFO" "Welcome to the PlayNix Flake installer!"
log "INFO" "The installer will log the installation process to $LOGFILE."

log "WARN" "This script will irreversibly format the *entire* target disk!

The following partitions will be created:

    - 1GB EFI System Partition      → /boot (label: NIXBOOT)
    - Custom-size Linux swap        → used as system swap (label: SWAP)
    - 100GB ext4 partition          → /persist  (label: PERSIST)
    - 700GB ext4 partition          → /home     (label: HOME)
    - Remaining space (ext4)        → /nix      (label: NIX)

Additionally:
    - The root (/) filesystem will be mounted as tmpfs (RAM) at boot
    - Impermanence will persist selected state to /persist
    - User and root passwords will be stored in /persist/etc/shadow.d"

# Ensure required tools are present
for cmd in blkdiscard sgdisk mkfs.ext4 mkfs.vfat mkswap swapon; do
    check_command "$cmd"
done

# Network connectivity check
if ! ping -c 1 github.com &> /dev/null; then
    log "ERROR" "Network connectivity check failed. Please ensure you have an active internet connection."
    exit 1
fi

log "INFO" "Your attached storage devices will now be listed."
read -p "Press enter to continue." NULL

printf "\n"

log "INFO" "Detected the following devices:"
lsblk

printf "\n"

read -p "Enter disk to install to (e.g., sda, nvme0n1): " DISKINPUT
DISK="/dev/$DISKINPUT"

if [ ! -b "$DISK" ]; then
    log "ERROR" "Disk not found: $DISK" "$RED"
    exit 1
fi

BOOTDISK="${DISK}p1"
SWAPDISK="${DISK}p2"
PERSISTDISK="${DISK}p3"
HOMEDISK="${DISK}p4"
NIXDISK="${DISK}p5"

log "INFO" "Boot Partition: $BOOTDISK"
log "INFO" "SWAP Partition: $SWAPDISK"
log "INFO" "Persist Partition: $PERSISTDISK"
log "INFO" "Home Partition: $HOMEDISK"
log "INFO" "Nix Partition: $NIXDISK"

log "INFO" "SWAP size selection"
read -p "How much Swap Size do you want? Enter in GB: " SWAPSIZE

if ! [[ "$SWAPSIZE" =~ ^[0-9]+$ ]] || [[ "$SWAPSIZE" -eq 0 ]]; then
    log "ERROR" "Invalid SWAPSIZE: $SWAPSIZE. Please enter a positive numeric value."
    exit 1
fi

do_format=$(yesno "Will now install PlayNix to ${DISK}. This irreversibly formats the entire disk. Are you sure?")
if [[ $do_format == "n" ]]; then
    exit
fi

sgdisk -p "$DISK" > /dev/null

log "INFO" "Erasing disk ${DISK} ..."
blkdiscard -f "$DISK"
sgdisk --zap-all "$DISK"
sgdisk -o "$DISK"

sgdisk -p "$DISK" > /dev/null

log "INFO" "Creating partitions..." "$BLUE"
sgdisk -n1:1M:+1G -t1:EF00 "$DISK"        # EFI boot
sgdisk -n2:0:+${SWAPSIZE}G -t2:8200 "$DISK"  # Swap
sgdisk -n3:0:+100G -t3:8300 "$DISK"  # 100 GB ext4 persist
sgdisk -n4:0:+700G -t4:8300 "$DISK"  # 700 GB home ext4
sgdisk -n5:0:0     -t5:8300 "$DISK"  # nix ext4 (rest of disk)

sgdisk -p "$DISK" > /dev/null

sleep 2
log "INFO" "Formatting partitions..." "$BLUE"
mkfs.vfat -n NIXBOOT "$BOOTDISK"
mkswap -L SWAP "$SWAPDISK"
swapon "$SWAPDISK"
mkfs.ext4 -L PERSIST "$PERSISTDISK"
mkfs.ext4 -L HOME "$HOMEDISK"
mkfs.ext4 -L NIX "$NIXDISK"

log "INFO" "Notifying kernel of partition changes..."
sgdisk -p "$DISK" > /dev/null
sleep 5

log "INFO" "Mounting partitions..." "$BLUE"
mkdir -p /mnt/boot
mount "$BOOTDISK" /mnt/boot
mount --mkdir "$PERSISTDISK" /mnt/persist
mount --mkdir "$HOMEDISK" /mnt/home
mount --mkdir "$NIXDISK" /mnt/nix

while true; do
    read -rp "Which host to install? (battlestation) " HOST
    case $HOST in
        battlestation) break ;;
        *) log "INFO" "Invalid host." "$YELLOW" ;;
    esac
done

## user setup logic based on host

# create /persist/etc/shadow.d
mkdir -p /mnt/persist/etc/shadow.d

# setup users with persistent passwords
# https://reddit.com/r/NixOS/comments/o1er2p/tmpfs_as_root_but_without_hardcoding_your/h22f1b9/
# create a password with for root and $user with:
# mkpasswd -m sha-512 'PASSWORD' | sudo tee -a /persist/etc/shadow.d/root
# set root password
while true; do
    # Prompt for the password
    echo -n "Enter password for user root: "
    stty -echo        # Disable echoing
    read root_password
    stty echo         # Re-enable echoing
    echo              # Move to a new line

    # Prompt for the password confirmation
    echo -n "Confirm password: "
    stty -echo
    read root_password_confirm
    stty echo
    echo              # Move to a new line

    # Check if passwords match
    if [ "$root_password" = "$root_password_confirm" ]; then
        echo "$root_password" | mkpasswd -m sha-512 --stdin | tee -a /mnt/persist/etc/shadow.d/root > /dev/null
        unset root_password root_password_confirm
        echo "Password set successfully."
        break
    else
        echo "Passwords do not match. Please try again."
    fi
done

# Set username based on chosen host
case $HOST in
    kvm | vmware )
        USER="redflake"
        ;;
    t580 )
        USER="pascal"
        ;;
    vps )
        USER="redcloud"
        ;;
    * )
        echo "Invalid host. Please select a valid host."
        ;;
esac

log "INFO" "You chose to install host $HOST. Automatically setting user to $USER."

# setup users with persistent passwords
# https://reddit.com/r/NixOS/comments/o1er2p/tmpfs_as_root_but_without_hardcoding_your/h22f1b9/
# create a password with for root and $user with:
# mkpasswd -m sha-512 'PASSWORD' | sudo tee -a /persist/etc/shadow.d/root
# set user password
while true; do
    # Prompt for the password
    echo -n "Enter password for user $USER: "
    stty -echo        # Disable echoing
    read user_password
    stty echo         # Re-enable echoing
    echo              # Move to a new line

    # Prompt for the password confirmation
    echo -n "Confirm password: "
    stty -echo
    read user_password_confirm
    stty echo
    echo              # Move to a new line

    # Check if passwords match
    if [ "$user_password" = "$user_password_confirm" ]; then
        echo "$user_password" | mkpasswd -m sha-512 --stdin | tee -a /mnt/persist/etc/shadow.d/$USER > /dev/null
        unset user_password user_password_confirm
        echo "Password set successfully."
        break
    else
        echo "Passwords do not match. Please try again."
    fi
done

# Set correct permissions for /persist/etc/shadow.d
chown -R root:shadow /mnt/persist/etc/shadow.d/
chmod -R 640 /mnt/persist/etc/shadow.d/

log "INFO" "Installing PlayNix with host profile ${HOST} for user ${USER} on disk ${DISK}..."
nixos-install --no-root-password --flake "${FLAKE}/${GIT_REV:-main}#$HOST" --option tarball-ttl 0

log "INFO" "Syncing disk writes..."
sync

log "INFO" "Setting up persistence..."
mkdir -p /mnt/persist/var/lib/

# setup NetworkManager persistence
mkdir -p /mnt/persist/etc/NetworkManager
if [ -d /etc/NetworkManager/system-connections ]; then
    cp -r /etc/NetworkManager/system-connections /mnt/persist/etc/NetworkManager/
fi

mkdir -p /mnt/persist/var/lib/NetworkManager
if [ -d /var/lib/NetworkManager ]; then
    cp /var/lib/NetworkManager/{secret_key,seen-bssids,timestamps} /mnt/persist/var/lib/NetworkManager/
fi

# setup ssl certs persistence
mkdir -p /mnt/persist/etc/ssl/
if [ -d /mnt/etc/ssl/certs ]; then
    cp -r /mnt/etc/ssl/certs/ /mnt/persist/etc/ssl/
fi

# setup machine-id persistence
mkdir -p /mnt/persist/etc/
cp /mnt/etc/machine-id /mnt/persist/etc/

# setup ssh host key persistence
mkdir -p /mnt/persist/etc/ssh
cp /mnt/etc/ssh/ssh_host_ed25519_key /mnt/persist/etc/ssh/
cp /mnt/etc/ssh/ssh_host_ed25519_key.pub /mnt/persist/etc/ssh/
cp /mnt/etc/ssh/ssh_host_rsa_key /mnt/persist/etc/ssh/
cp /mnt/etc/ssh/ssh_host_rsa_key.pub /mnt/persist/etc/ssh/

log "INFO" "Unmouting /mnt/boot"
umount -f /mnt/boot

log "INFO" "Unmouting /mnt/persist"
umount -f /mnt/persist

log "INFO" "Unmouting /mnt"
umount -f /mnt

log "INFO" "Installation finished. It is now safe to reboot."

do_reboot=$(yesno "Do you want to reboot now?")
if [[ $do_reboot == "y" ]]; then
    reboot
fi
