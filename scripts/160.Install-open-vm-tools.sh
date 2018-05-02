#!/bin/bash

#        Copyright Abdessattar Sassi 2018.
#    Distributed under the 3-Clause BSD License.
#    (See accompanying file LICENSE or copy at
#   https://opensource.org/licenses/BSD-3-Clause)

set -e

source $(dirname $0)/shell-helpers.sh

asis_warn
echo -e
shw_norm "This script will install open-vm-tools and setup the environment \
to take advantage of VmWare host-guest integration features."
echo -e

shw_norm "1. Updating /etc/arch-release for open-vm-tools"
cat /proc/version | sudo tee /etc/arch-release >/dev/null

shw_norm "2. Installing open-vm-tools"
aurman -S --noconfirm --needed open-vm-tools

shw_norm "3. Starting and enabling services needed by VmWare Tools"
sudo systemctl start vmtoolsd.service
sudo systemctl enable vmtoolsd.service
sudo systemctl start vmware-vmblock-fuse.service
sudo systemctl enable vmware-vmblock-fuse.service
shw_norm "Done."
echo -e
shw_grey "You should now have access to shared folders and other integration \
features betwen guest and host."
echo -e
shw_grey "To mount a shared folder, use vmhgfs-fuse (e.g.: sudo mhfs-fuse -o allow-other \
.host:/Music /mnt/hgfs/Music)."
echo -e
shw_grey "To persist the mount after reboot, add the following to /etc/fstab:"
shw_grey ".host:/Music /mnt/hgfs/Music fuse.vmghfs-fuse allow-_other,uid=0,gid=0,auto_mount,defaults 0 0"
echo -e
