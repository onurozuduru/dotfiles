#!/bin/bash
# shellcheck disable=2155

PWD=$(pwd -P)

COMMANDS_LIST=('curl' 'wget' 'git' 'ffmpeg' 'ctags' 'tmux' 'xsel' 'clang-tools' 'clang-tidy' 'clang-format' 'ccache' 'gdb' 'autoconf' 'doxygen' 'gcc' 'g++' 'make' 'cmake' 'pipx')
NOT_FOUND=()
PACKAGES_LIST=('build-essential' 'python3-venv' 'python3-pip' 'python3-dev' 'autotools-dev' 'libboost-all-dev' 'software-properties-common' 'openssh-client' 'imagemagick')
PIP_LIST=('cpplint' 'cppclean' 'pynvim' 'python-language-server' 'ipython')

## Goes $1 and does $2
## $1: directory to go
## $2: command to execute in dir
go_there_do_that() {
	echo "---------------------------------------BEGIN------------------------------------"
	# shellcheck disable=2145
	echo ">>>$@>>>"
	echo "<<<>>>"
	cd "$1" || echo "Failed: cd $1"
	shift && "$@"
	echo "----------------------------------------END-------------------------------------"
}

## $1: message
log_this() {
	echo "*** $1 ***"
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
	curl -LO "$latest_download_url"
	if [[ "$type" == "deb" ]]; then
		sudo dpkg -i "$download_name"
	else
		local bin_name="${download_name%.appimage}"
		mkdir "$bin_name"
		mv "$download_name" "$bin_name/$download_name"
		chmod +x "$bin_name/$download_name"
		"$bin_name/$download_name" --appimage-extract
		ln -s "$bin_name/$download_name/squashfs-root/usr/bin/$bin_name" "$HOME/.local/bin/$bin_name"
	fi
}

### Check if package exist and install
## $1: package name
install_package() {
	PKG_AV=$(sudo apt-cache search "$1")
	if [ -z "$PKG_AV" ]; then
		log_this "!!! Package $1 is not available for installation!"
		return
	fi
	PKG_OK=$({ dpkg-query -W --showformat='${Status}\n' "$1" | grep "install ok installed"; } 2>&1)
	if [ -z "$PKG_OK" ]; then
		log_this "Installing $1"
		sudo apt-get -qq install -y "$1" >/dev/null
	else
		log_this "$1 already installed!"
	fi
}

## Pass given argument to apt
# $1: package name
install_with_apt() {
	log_this "Installing with apt: $1"
	sudo apt install "$1"
}

## Pass given argument to pip
# $1: package name
install_with_pipx() {
	log_this "Installing with pipx: $1"
	pipx install "$1"
}

tmux_plugins() {
	log_this "Installing plugin manager for tmux"
	export TMUX_PLUGIN_MANAGER_PATH="${HOME}/.tmux/plugins"
	git clone https://github.com/tmux-plugins/tpm ${TMUX_PLUGIN_MANAGER_PATH}/tpm >/dev/null 2>&1
	log_this "Installing plugins"
	${TMUX_PLUGIN_MANAGER_PATH}/tpm/scripts/install_plugins.sh >/dev/null 2>&1
	tmux source ~/.tmux.conf
}

install_fzf() {
	if ! installed fzf; then
		git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
		~/.fzf/install --no-zsh --no-fish
	fi
}

for command in "${COMMANDS_LIST[@]}"; do
	echo "Checking command $command..."
	if ! installed "$command"; then
		NOT_FOUND+=("$command")
	fi
done

log_this "Could not found those commands, they will be installed:"
echo "${NOT_FOUND[@]}"

for i in "${NOT_FOUND[@]}"; do
	go_there_do_that "$PWD" install_with_apt "$i"
done

log_this "Installing packages:"
echo "${PACKAGES_LIST[@]}"
log_this "---"

for i in "${PACKAGES_LIST[@]}"; do
	go_there_do_that "$PWD" install_package "$i"
done

log_this "Installing PIP:"
echo "${PIP_LIST[@]}"
log_this "---"

for i in "${PIP_LIST[@]}"; do
	go_there_do_that "$PWD" install_with_pipx "$i"
done

# Install ripgrep
if ! installed rg; then
	install_from_github BurntSushi ripgrep deb
fi

# Install neovim appimage
if ! installed nvim; then
	install_from_github neovim neovim appimage
fi

if ! installed npm; then
	sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg
	curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
	NODE_MAJOR=20
	echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
	sudo apt-get update && sudo apt-get install nodejs -y
fi

install_fzf
tmux_plugins
