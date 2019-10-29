#!/bin/bash

#        Copyright Abdessattar Sassi 2018.
#    Distributed under the 3-Clause BSD License.
#    (See accompanying file LICENSE or copy at
#   https://opensource.org/licenses/BSD-3-Clause)

set -e

source $(dirname $0)/shell-helpers.sh

asis_warn
echo -e ''
shw_norm "This script will install yay from github (https://github.com/Jguer/yay)."
echo -e
shw_norm "1. Checking if you have git and installing it if needed"

if ! pacman -Qi git &>/dev/null; then
	sudo pacman -S --noconfirm git
fi

yay_repo="https://github.com/Jguer/yay.git"
shw_norm "2. Cloning yay git repo from $yay_repo"
git clone $yay_repo

shw_norm "3. Executing build-Package-Install"
cd yay && makepkg -si
cd .. && rm -rf yay
shw_norm "Done."
