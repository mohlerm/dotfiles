setup
=====

Arch Linux with i3 WM config
running on a Thinkpad T14s

BTRFS on LUKS with EFISTUB.

# SSH

I recommend doing the installation from a second PC via SSH. This allows easy copy/pasting.
```
# systemctl enable sshd.service --now
# passwd
# ip addr show
```
on second PC
```
# ssh root@IP
```

# Preparation

Ensure clock is up to date
```
# timedatectl set-ntp true
```

# Partitioning

I assume your disk is `/dev/nvme0n1`, please adjust if otherwise. Create two partitions, one for boot and one for the OS. Run `gdisk`
```
# gdisk /dev/nvme0n1
o (create a new empty GUID partition table (GPT))
Proceed? (Y/N): y

n (add a new partition)
Partition number (1-128, default 1): 1
First sector : (hit enter)
Last sector : +512MB
Hex code or GUID: ef00

n (add a new partition)
Partition number (2-128, default 2): 2
First sector : (hit enter)
Last sector : (hit enter - rest of disk)
Hex code or GUID: (hit enter, default, 8300)

w
Do you want to proceed? (Y/N): y
```
Setup encryption
```
cryptsetup luksFormat /dev/nvme0n1p2
Are you sure? YES
(enter passphrase)
cryptsetup luksOpen /dev/nvme0n1p2 cryptroot
```
Format partitions
```
# mkfs.fat -F32 -n EFI /dev/nvme0n1p1
# mkfs.btrfs -L ROOT /dev/mapper/cryptroot
```
Create subvolumes for root, home and snapshots
```
# mount /dev/mapper/cryptroot /mnt
# btrfs sub create /mnt/@
# btrfs sub create /mnt/@home
# btrfs sub create /mnt/@snapshots
# umount /mnt
```
Mount the subvolumes
```
# mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@ /dev/mapper/cryptroot /mnt
# mkdir -p /mnt/{boot,home,.snapshots,swap}
# mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@home /dev/mapper/cryptroot /mnt/home
# mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@snapshots /dev/mapper/cryptroot /mnt/.snapshots
# mount -o noatime,nodiratime,compress=zstd,space_cache,ssd,subvol=@snapshots /dev/mapper/cryptroot /mnt/swap
```
Mount EFI
```
# mkdir /mnt/boot
# mount /dev/nvme0n1p1 /mnt/boot
```

# Swapfile

I create a swapfile, mainly for hibernate (later we lower the swappiness)
```
# cd /swap
# truncate -s 0 swapfile
# chattr +C swapfile
# btrfs property set swapfile compression none
# dd if=/dev/zero of=/swap/swapfile bs=1G count=32 status=progress
# chmod 600 swapfile
# mkswap /swap/swapfile
# swapon /swap/swapfile
```

# Installation

## Pacstrap

Install packages
```
# pacstrap /mnt base linux linux-firmware 
```

## Fstab

Generate Fstab
```
genfstab -U /mnt >> /mnt/etc/fstab
```
It should look similar to
```
# Static information about the filesystems.
# See fstab(5) for details.

# <file system> <dir> <type> <options> <dump> <pass>
# /dev/mapper/cryptroot LABEL=ROOT
UUID=dd7ad475-5566-43cc-9078-064b898980be	/         	btrfs     	rw,noatime,compress=zstd:3,ssd,space_cache=v2,subvolid=256,subvol=/@	0 0

# /dev/nvme0n1p1 LABEL=EFI
UUID=02DC-8178      	/boot     	vfat      	rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro0 2

# /dev/mapper/cryptroot LABEL=ROOT
UUID=dd7ad475-5566-43cc-9078-064b898980be	/home     	btrfs     	rw,noatime,compress=zstd:3,ssd,space_cache=v2,subvolid=257,subvol=/@home	0 0

# /dev/mapper/cryptroot LABEL=ROOT
UUID=dd7ad475-5566-43cc-9078-064b898980be	/.snapshots	btrfs     	rw,noatime,compress=zstd:3,ssd,space_cache=v2,subvolid=258,subvol=/@snapshots0 0

# /dev/mapper/cryptroot LABEL=ROOT
UUID=dd7ad475-5566-43cc-9078-064b898980be	/swap     	btrfs     	defaults,noatime,subvolid=259,subvol=/@swap	0 0

/swap/swapfile      	none      	swap      	defaults  	0 0
```

## Chroot

```
# arch-chroot /mnt
```

## Install remaining packages

```
# pacman -S efibootmgr amd-ucode vim feh betterlockscreen xorg-server xf86-video-amdgpu xf86-video-vesa arc-gtk-theme arc-icon-theme dunst cups fwupd git i3wm i3status scrot sudo terminus-font gnome firefox autorandr fish htop libreoffice-fresh light networkmanager network-manager-applet network-manager-openvpn openconnect pavucontrol picom remmina rofi-pass signal-desktop thunderbird tlpd ttf-ubuntu-font-family xbindkeys rofi rofi-pass seahorse gnupg
```

## Timezone

```
# ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime
# hwclock --systohc
```

## Localization

```
# locale-gen
# vim /etc/locale.conf
LANG=en_US.UTF-8
```

## Hostname

```
# vim /etc/hostname
miraculix
```

## Initramfs

Modify `/etc/mkinitcpio.conf` and change `HOOKS` & `MODULES` array to the following
```
MODULES=(amdgpu)
HOOKS=(base systemd autodetect keyboard modconf block sd-encrypt btrfs filesystems fsck)
```
then run
```
# mkinitcpio -P
```

## Bootmanager EFISTUB

```
sudo efibootmgr --disk /dev/nvme0n1 --part 1 --create --label 'Arch Linux' --load /vmlinuz-linux --unicode 'rd.luks.name=b367ea26-49a6-400a-a0fb-9ac570327d44=cryptroot rd.luks.options=discard,tpm2-device=auto root=/dev/mapper/cryptroot resume=UUID=dd7ad475-5566-43cc-9078-064b898980be resume_offset=876227 rw rootflags=subvol=@ initrd=\amd-ucode.img initrd=\initramfs-linux.img' --verbose
```

## Set root pw

```
passwd
```

## Reboot

```
exit
reboot
```


# Various

## sudo
```
# EDITOR=vim visudo
```
Uncomment `wheel` in `/etc/sudoers` and add your user to wheel

## User

```
# useradd --create-home --groups wheel NAME
# passwd NAME
# passwd --lock root
```
Now work with that user

## Networkmanager
```
# sudo systemctl enable NetworkManager --now
```

## CUPS
```
# sudo systemctl enable cups.socket --now
```

## TLP
Review `/etc/tlp.conf` and start service
```
# sudo systemctl enable tlp.service --now
```

## Hibernate
See https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Hibernation_into_swap_file_on_Btrfs

## Trim
```
# sudo lsblk --discard
# sudo systemctl enable fstrim.timer --now
```

## AUR helper
```
# git clone https://aur.archlinux.org/yay.git /tmp/yay
# cd /tmp/yay
# makepkg -si
```

## Use TPM for LUKS
```
# sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/nvme0n1p2
After firmware update you might want to delete the old tpm keys first
# sudo systemd-cryptenroll --wipe-slot=tpm2  /dev/nvme0n1p2
```

## Pinentry
See https://wiki.archlinux.org/title/GnuPG#pinentry

## GDM autologin
```
# sudo vim /etc/gdm/custom.conf

# Enable automatic login for user
[daemon]
AutomaticLogin=username
AutomaticLoginEnable=True
```

## Bluetooth after suspend
```
# sudo vim /etc/bluetooth/main.conf
AutoEnable=true
```

## Swappiness
```
# echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-swappiness.conf
```

## Time sync
```
timedatectl set-ntp true
```

## Fwupd
```
sudo mkdir /boot/EFI
systemctl restart fwupd.service
sudo fwupdmgr update
```

# Sources
https://wiki.archlinux.org/title/Installation_guide

https://rich.grundy.io/blog/archlinux-on-encrypted-btrfs-with-systemd-boot-and-kde/

https://www.nerdstuff.org/posts/2020/2020-004_arch_linux_luks_btrfs_systemd-boot/

https://blog.bespinian.io/posts/installing-arch-linux-on-uefi-with-full-disk-encryption/

