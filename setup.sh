#!/bin/bash
###############################################################################
#File: install_things.sh
#
#License: MIT
#
#Copyright (C) 2024 Onur Ozuduru
#
#Follow Me!
#  github: github.com/onurozuduru
###############################################################################
# shellcheck disable=2155

INSTALL_DIR=$(pwd -P)
REPO_DOTHOME="https://github.com/onurozuduru/dothome.git"
REPO_DOTFILES="https://github.com/onurozuduru/dotfiles.git"

print_help() {
	echo "Usage: $0 [-d|--install_dir <DIR>] [-h|--help]"
	echo -e "Install necessary packages for developer environment setup on Ubuntu/Debian."
	echo -e "\t-d,--install_dir <DIR>\tInstall directory. Default is the current dir: $INSTALL_DIR"
	echo -e "\t-h,--help\tDisplay help."
}

### Get params
# -l long options (--help)
# -o short options (-h)
# : options takes argument (--option1 arg1)
# $@ pass all command line parameters.
set -e
params=$(getopt -l "list,help" -o "lyh" -- "$@")

eval set -- "$params"

while true; do
	case $1 in
	-h | --help)
		print_help
		exit 0
		;;
	-d | --install_dir)
		shift
		INSTALL_DIR="$1"
		;;
	--)
		shift
		break
		;;
	*)
		print_help
		exit 0
		;;
	esac
	shift
done

cd "$INSTALL_DIR"
DOTHOME_DIR="$INSTALL_DIR/dothome"
DOTHOME="$DOTHOME_DIR/dothome"
DOTFILES="dotfiles"
DOTFILES_DIR="$INSTALL_DIR/$DOTFILES"

set +e

## $1: message
log_this() {
	echo ">>> $1"
}

## $1: message
log_error() {
	log_this "!!! $1"
}

## $1: command
## $? 1: if not found
installed() {
	COMMAND_EXEC=$(command -v "$1")
	if ! [ -x "$COMMAND_EXEC" ]; then
		echo "$1 is not installed!"
		return 1
	fi
}

## $1: user
## $2: repo
## $3: type -> deb | appimage
install_from_github() {
	local user="$1"
	local repo="$2"
	local type="$3"
	log_this "Installing '${type}' from GitHub: ${user}/${repo}"
	local latest_download_url=$(curl -s "https://api.github.com/repos/${user}/${repo}/releases/latest" | awk -F '"' '/browser_download_url/{print $4}' | grep "${type}" | grep -v "${type}.")
	local download_name=$(basename "$latest_download_url")
	log_this "Found: $download_name"
	curl -LO "$latest_download_url" || return
	if [[ "$type" == "deb" ]]; then
		sudo dpkg -i "$download_name"
	else
		local bin_name="${download_name%.appimage}"
		local bin_dir="$HOME/${bin_name}"
		if [[ -f "$bin_dir/$download_name" ]]; then
			log_error "Already exists: $bin_dir/$download_name"
			return
		fi
		mkdir "$bin_dir"
		mv "$download_name" "$bin_dir/$download_name"
		chmod +x "$bin_dir/$download_name"
		# shellcheck disable=2015
		cd "${bin_dir}" && "./$download_name" --appimage-extract >/dev/null && cd - ||
			log_error "A problem occured while installing $bin_dir"
		ln -s "$bin_dir/squashfs-root/usr/bin/$bin_name" "$HOME/.local/bin/$bin_name" ||
			log_error "Could not create link: '$HOME/.local/bin/$bin_name' -> '$bin_dir/squashfs-root/usr/bin/$bin_name'"
	fi
	if [[ -f "$download_name" ]]; then
		log_this "Cleaning: $download_name"
		rm -f "$download_name"
	fi
}

## The special ones that cannot be installed properly from Debian/Ubuntu source
## Up to date packages are hard!

# Install ripgrep
if ! installed rg; then
	install_from_github BurntSushi ripgrep deb
fi

# Install neovim appimage
if ! installed nvim; then
	install_from_github neovim neovim appimage
fi

if ! installed fzf; then
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --no-zsh --no-fish
fi

# Mason uses node for some programs
if ! installed npm; then
	sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg
	curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
	NODE_MAJOR=20
	echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
	sudo apt-get update && sudo apt-get install nodejs -y
fi

mkdir -p ~/.local/bin

if [[ ! -d "${HOME}/.tmux/plugins" ]]; then
	log_this "Installing plugin manager for tmux"
	export TMUX_PLUGIN_MANAGER_PATH="${HOME}/.tmux/plugins"
	git clone https://github.com/tmux-plugins/tpm "${TMUX_PLUGIN_MANAGER_PATH}/tpm"
	log_this "Installing plugins"
	"${TMUX_PLUGIN_MANAGER_PATH}/tpm/scripts/install_plugins.sh" >/dev/null 2>&1
	tmux source ~/.tmux.conf
	"${TMUX_PLUGIN_MANAGER_PATH}/tpm/scripts/install_plugins.sh" >/dev/null 2>&1
fi

## Setup dotfiles

if [[ ! -d "$DOTHOME_DIR" ]]; then
	git clone "$REPO_DOTHOME" "$DOTHOME_DIR" || log_error "Could not clone: $DOTHOME"
fi
chmod +x "$DOTHOME"

if [[ ! -d "$DOTFILES_DIR" ]]; then
	git clone "$REPO_DOTFILES" "$DOTFILES_DIR" || log_error "Could not clone: $DOTFILES"
fi

if [[ ! -x "$DOTHOME" ]]; then
	log_error "Not executable: $DOTHOME"
	exit 0
fi

$DOTHOME --base "$INSTALL_DIR" --dotfiles "$DOTFILES" --init
