#!/bin/bash

#        Copyright Abdessattar Sassi 2018.
#    Distributed under the 3-Clause BSD License.
#    (See accompanying file LICENSE or copy at
#   https://opensource.org/licenses/BSD-3-Clause)

set -e

source $(dirname $0)/shell-helpers.sh

asis_warn
echo -e
shw_norm "This script will use reflector and pacman rankmirrors to get up-to-date mirrors for Arch and rank them 
based on their rate. If reflector is not already installed, it will install it."
echo -e
shw_norm "1. Checking if you have reflector and installing it if needed"

if ! pacman -Qi reflector &>/dev/null; then
	sudo pacman -S --noconfirm reflector
fi

shw_norm "2. Optimizing mirror list"
mirrorlist="/etc/pacman.d/mirrorlist"
backup_mirrorlist="$mirrorlist.backup"
shw_norm "\tbacking current mirrors list to $mirrorlist_backup"
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
shw_norm "\tgetting and sorting new mirror list using reflector (be patient)"
reflector -l 200 -f 50 --sort rate --threads 5 --save /tmp/mirrorlist.new
echo -e
shw_grey "\tTOP 10 after reflector's work"
shw_grey "     -----------------------------"
grep -v "^\($\|#\)" /tmp/mirrorlist.new | head -10 | cat -n
echo -e
shw_norm "\tranking new mirrorlist with rankmirrors (be patient)"
rankmirrors -n 0 /tmp/mirrorlist.new | sudo tee /etc/pacman.d/mirrorlist >/dev/null
echo -e
shw_grey "\tTOP 10 after rankmirror's work"
shw_grey "\t-----------------------------"
grep -v "^\($\|#\)" /etc/pacman.d/mirrorlist | head -10 | cat -n
echo -e
shw_norm "3. Refreshing pacman"
sudo pacman -Syu
shw_norm "Done."
