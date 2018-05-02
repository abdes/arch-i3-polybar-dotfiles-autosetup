#!/bin/bash

#        Copyright Abdessattar Sassi 2018.
#    Distributed under the 3-Clause BSD License.
#    (See accompanying file LICENSE or copy at
#   https://opensource.org/licenses/BSD-3-Clause)

set -e

source $(dirname $0)/shell-helpers.sh

asis_warn
cat <<EOF
$(tput setaf 7)
This script will setup the packages and user files necessary for a fully functional environment. Both command line tools and graphical tools will be installed. For the display server, Xorg is chosen. For the desktop environment, both a basic minimal setup using twm and openbox as window managers will be setup as well as fully customized i3wm/polybar based environment.

All necessary folders in the user home directory will be created and dotfiles will be configured as needed. $(tput bold)Look inside the script for the details of what packages are being installed and what directories/dotfiles will be created.
$(tput sgr 0)

EOF

################################################################################
# Printing
################################################################################
shw_norm "1. Printing subsystem and tools"
packages=(
	"cups"
	"cups-pdf"
	"ghostscript"
	"gsfonts"
	"libcups"
	"hplip"
	"system-config-printer"
)
aurman -S --noconfirm --needed $packages
check_enable_service org.cups.cupsd.service
check_start_service org.cups.cupsd.service

################################################################################
# Sound
################################################################################
shw_norm "2. Sound subsystem (alsa, pulseaudio and other tools)"

# First alsa
packages=(
	"alsa-utils"
	"alsa-plugins"
	"alsa-lib"
	"alsa-firmware"
)
aurman -S --noconfirm --needed $packages

# Then pulseaudio
packages=(
	"pulseaudio"
	"pulseaudio-alsa"
	"pavucontrol"
)
aurman -S --noconfirm --needed $packages

################################################################################
# Terminal tools
################################################################################
shw_norm "3. Terminal tools"
packages=(
	"fzf"
	"vim"
	"zsh"
	"oh-my-zsh-git"
	"htop"
	"glances"
	"neofetch"
	"wget"
)
aurman -S --noconfirm --needed $packages
# Change shell to zsh
new_shell='/usr/bin/zsh'
if [ $SHELL != $new_shell ]; then
	shw_grey "Setting sheel for current user from $SHELL to $new_shell"
	chsh -s $new_shell
fi

################################################################################
# Zippers/Unzippers
################################################################################
shw_norm "4. Zip/Unzip tools"
packages=(
	"unace"
	"unrar"
	"zip"
	"unzip"
	"sharutils"
	"uudeview"
	"arj"
	"cabextract"
)
aurman -S --noconfirm --needed $packages

################################################################################
# Xorg, drivers and additional apps/tools for Xorg
################################################################################
shw_norm "5. Xorg and related apps/tools"
shw_norm "First we need to know which drivers we need to use."
prompt="Pick an option:"
options=("VmWare" "ATI" "Intel" "Nvidia" "Not needed")

PS3="$prompt "
select opt in "${options[@]}" "Quit!"; do

	case "$REPLY" in

	1)
		drivers="xf86-input-vmmouse xf86-video-vmware"
		break
		;;
	2)
		drivers="xf86-video-ati"
		break
		;;
	3)
		drivers="xf86-video-intel"
		break
		;;
	4)
		drivers="xf86-video-nouveau"
		break
		;;
	5) break ;;

	$((${#options[@]} + 1)))
		shw_warn "Setup is not done."
		shw_norm "Figure out the correct option then you can restart the script any time later."
		shw_norm "Bye!"
		exit 0
		;;
	*) echo "Invalid option. Try again..." ;;

	esac

done

[ -n "$drivers" ] && shw_grey "Using these drivers: $drivers"
packages=(
	"xorg-server"
	"xorg-apps"
	"xorg-xinit"
	"xorg-fonts-100dpi"
	"xterm"
	"xorg-twm"
	"compton"
)
aurman -S --noconfirm --needed $drivers $packages

################################################################################
# Additional Fonts
################################################################################
shw_norm "6. Additional fonts, including icon fonts and powerline"
packages=(
	"cantarell-fonts"
	"noto-fonts"
	"powerline-fonts"
	"system-san-francisco-font-git"
	"ttf-freefont"
	"ttf-ubuntu-font-family"
	"ttf-bitstream-vera"
	"ttf-croscore"
	"ttf-dejavu"
	"ttf-droid"
	"ttf-hack"
	"ttf-liberation"
	"ttf-material-design-icons"
	"adobe-source-code-pro-fonts"
)
aurman -S --noconfirm --needed $packages

################################################################################
# OpenBox Window Manager as an alternative
################################################################################
shw_norm "7. OpenBox Window Manager if you need an alternative to tiling :-)"
packages=(
	"openbox"
	"obconf"
)
aurman -S --noconfirm --needed $packages

################################################################################
# GUI applications
################################################################################
shw_norm "8. Some GUI applications (most are used for the i3wm customization)..."
packages_must=(
	"rxvt-unicode"
	"urxvt-perls"
	"urxvt-font-size-git"
	"termite"
	"feh"
	"clipit"
	"dunst"
	"rofi"
)
packages_opt=(
	"nemo"
	"file-roller"
	"firefox"
	"thunderbird"
	"lxappearance-gtk3"
)
aurman -S --noconfirm --needed $packages_must $packages_opt

################################################################################
# i3wm and polybar
################################################################################
shw_norm "9. Installing i3wm and polybar"
packages=(
	"i3lock"
	"i3status"
	"i3blocks"
	"i3-gaps"
)
aurman -S --noconfirm --needed $packages
# Polybar must be built after i3wm is installed or it will not be enabled
shw_grey "Installing polybar"
aurman -S --noconfirm --needed polybar-git

################################################################################
# Themes
################################################################################
shw_norm "10. Minimal suggested themes for GTK"
packages=(
	"adwaita-icon-theme"
	"breeze-snow-cursor-theme"
	"gtk-arc-flatabulous-theme"
	"hicolor-icon-theme"
)
aurman -S --noconfirm --needed $packages

################################################################################
# Folders and dotfiles needed in user home
################################################################################
shw_norm "11. Creating necessary folders in user home if not present..."
[ -d $HOME"/.icons" ] || mkdir -p $HOME"/.icons"
[ -d $HOME"/.config/gtk-3.0" ] || mkdir -p $HOME"/.config/gtk-3.0"
[ -d $HOME"/.themes" ] || mkdir -p $HOME"/.themes"
[ -d $HOME"/Desktop" ] || mkdir -p $HOME"/Desktop"
[ -d $HOME"/Documents" ] || mkdir -p $HOME"/Documents"
[ -d $HOME"/Downloads" ] || mkdir -p $HOME"/Downloads"
[ -d $HOME"/Music" ] || mkdir -p $HOME"/Music"
[ -d $HOME"/Pictures" ] || mkdir -p $HOME"/Pictures"
[ -d $HOME"/Videos" ] || mkdir -p $HOME"/Videos"
[ -d $HOME"/.fonts" ] || mkdir -p $HOME"/.fonts"

shw_norm "12. Installing dotfiles in home..."
declare -A dotfiles=(
	["Xresources"]=".Xresources"
	["xinitrc"]=".xinitrc"
	["zshrc"]=".zshrc"
	["config/termite/config"]=".config/termite/config"
	["config/rofi/iron.rasi"]=".config/rofi/iron.rasi"
	["config/rofi/config"]=".config/rofi/config"
	["config/gtk-2.0/gtkfilechooser.ini"]=".config/gtk-2.0/gtkfilechooser.ini"
	["config/gtk-3.0/settings.ini"]=".config/gtk-3.0/settings.ini"
	["config/gtk-3.0/bookmarks"]=".config/gtk-3.0/bookmarks"
	["config/compton.conf"]=".config/compton.conf"
	["config/i3/layouts/1.json"]=".config/i3/layouts/1.json"
	["config/i3/layouts/2.json"]=".config/i3/layouts/2.json"
	["config/i3/layouts/3.json"]=".config/i3/layouts/3.json"
	["config/i3/config"]=".config/i3/config"
	["config/i3/restore.sh"]=".config/i3/restore.sh"
	["config/dunst/dunstrc"]=".config/dunst/dunstrc"
	["config/polybar/launch.sh"]=".config/polybar/launch.sh"
	["config/polybar/pkg.sh"]=".config/polybar/pkg.sh"
	["config/polybar/redshift.sh"]=".config/polybar/redshift.sh"
	["config/polybar/config"]=".config/polybar/config"
	["Xresources.d/rxvt-unicode"]=".Xresources.d/rxvt-unicode"
	["Xresources.d/colors"]=".Xresources.d/colors"
	[".gtkrc-2.0"]=".gtkrc-2.0"
)

for file in "${!dotfiles[@]}"; do
	source="../dotfiles/$file"
	dest="$HOME/${dotfiles[$file]}"
	if [ -f $dest ]; then
		shw_warn "$dest exists. Skipping"
	else
		shw_grey "$dest"
		mkdir -p $(dirname $dest) && cp $source $dest
	fi
done

################################################################################
# Display Manager
################################################################################
shw_norm "13. Display Manager (will be active after reboot)"

aurman -S --noconfirm --needed sddm
sudo mkdir -p /etc/sddm.conf.d
sddm --example-config | sudo tee /etc/sddm.conf.d/sddm.conf >/dev/null
sudo systemctl enable sddm.service

shw_norm "Done."
shw_norm "Please reboot now."
