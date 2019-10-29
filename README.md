# Lightweight development system based on Arch Linux, i3wm and polybar

This is my attempt to share my custom environment for development built on Arch Linux, using i3wm as my window manager. All dotfiles and a couple of scripts are included to automate as much as possible the setup. The scripts in general play nice and do not attempt at destroying existing stuff. It is recommended however to either do this setup on a new machine, a VM or at least on a new fresh user.

All files are provided under BSD 3-Clause License and as such, you can do anything with them as long as you understand clause 3 :-).

Many thanks to https://github.com/erikdubois/Archi3 for inspiring me to use Arch Linux and for the huge amount of contributions he has made to the Arch community and from which I learned a lot. Additional thanks to https://github.com/blackbart420/dotfiles for his polybar theme which I heavily reused and for his rofi iron theme.

## 100 - Install Arch Linux base system

### 110 - Bootstrap the system

Follow instructions at https://wiki.archlinux.org/index.php/installation_guide while paying attention to the following important points/tips:

> Everything that follows is relevant for an installation of **64 bit** system with an **EFI** boot.

* Check your boot type especially if you are planning to use EFI. If installing on a VM using VmWare, select EFI boot in VM Settings->Options->Advanced->Firmware Type.
* Set timezone and correct date/time (enable ntp) using [`timedatectl(1)`](https://jlk.fjfi.cvut.cz/arch/manpages/man/timedatectl.1)
* Partition the disk and format the partitions properly. Recommended layout for EFI/GPT in the table below.

| Mount point | Partition | Suggested size | Partition type GUID | Filesystem format |
|---|---|---|---|---|
| /boot | /dev/sda1 | 0.5G | C12A7328-F81F-11D2-BA4B-00A0C93EC93B: EFI System Partition | `# mkfs.fat -F32 /dev/sda1` |
| / | /dev/sda2 | 23-32G | 4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709: Linux x86-64 root (/) | `# mkfs.ext4 /dev/sda2` |
| [SWAP] | /dev/sda3 | 2-4G | 0657FD6D-A4AB-43C4-84E5-0933C84B4F4F: Linux swap | `# mkswap /dev/sda3` |
| /home | /dev/sda4 | Remainder of the device | 933AC7E1-2EB4-4F13-B844-0E14E2AEF915: Linux /home | `# mkfs.fat -F32 /dev/sda1` |

* Bootstrap the Arch system (base-devel is needed later and for that matter we just get it done now, bash-completion will make things faster, and git will help us get scripts and stuff from github).

```bash
# pacstrap -i /mnt base base-devel bash-completion git
```

* Finish configuring the system as in the Arch installation guide until reboot.
  * Install networkmanager,
  * Install a booloader, for example `grub`,

  ```bash
  # pacman -S networkmanager
  # systemctl enable NetworkManager

  # pacman -S grub efibootmgr
  # grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
  # grub-mkconfig -o /boot/grub/grub.cfg
  ```

  * Customize grub configuration to your liking...
  * Reboot.

### 120 - Create a new user

* Create a new user and set its password

```bash
# useradd -m -g users -G wheel,storage,power -s /bin/bash <user name here>
# passwd <user name here>
```

* Add the new user to the sudoers list (individually or as part of group *`wheel`*)

```bash
# visudo
```

* Login with the new user account

### 130 - Get the setup scripts

Clone the repo from github / download zip from github /etc. Whatever the method you use, keep the same structure of the directories and files for the scripts to work transparently.

### 140 - Update mirror list for speed

Arch reflector is a tool that can test the mirrors in the pacman mirrorlist for freshness and speed and reorder it accordingly.

```bash
# 140.Optimize-arch-mirrors.sh
```

### 150 - Install yay

[`yay`](https://github.com/Jguer/yay) will help us get user contributed packages from AUR and simplify/automate their build/installation.

```bash
# 150.Install-yay-from-github.sh
```

### 160 - VmWare specific instructions

```bash
# 160.Install-open-vm-tools.sh
```

You should now have access to shared folders between host and guest and other integration features provided by VmWare.

To mount a shared folder in the guest, use vmhgfs-fuse, e.g.:

```bash
sudo vmhgfs-fuse -o allow-other .host:/Music /mnt/hgfs/Music
```

To mount the folder at reboot (as long as Shared Folders are enabled in VmWare for the VM), add the following to /etc/fstab:

```bash
.host:/Music /mnt/hgfs/Music fuse.vmhgfs-fuse allow_other,uid=0,gid=0,auto_unmount,defaults 0 0
```

## 200 Install the rest of the desktop environment

This part will finish the installation by loading Xorg, window managers, display manager, fonts and applications. There will be 2 options available:

1. Traditional OpenBox window manager (with no customization),
2. Fully customized and styled i3wm tiled window manager with polybar.

All dotfiles will be installed in their places at the home directory.

After the setup is finished, it will be possible to select which environment to use from the display manager login.

```bash
# 210.Install-desktop.sh
```