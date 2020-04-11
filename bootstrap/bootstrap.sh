#!/usr/bin/env bash

set -eu

export DEBIAN_FRONTEND=noninteractive

NVIM_VERSION="0.4.3"
GO_VERSION="1.14.2"
NODE_VERSION="13"

apt-upgrade() {
	echo " ==> Upgrading packages"
	sudo apt update && sudo apt upgrade -y
	sudo apt auto-remove -y
}

apt-installs() {
	echo " ==> Installing base packages"
	sudo apt install -y \
		zsh \
		tmux \
		mosh \
		git \
		htop \
		iftop \
		python \
		python-pip

	sudo apt auto-remove -y
}

additional-installs() {
	if [ ! -d "${HOME}/.oh-my-zsh" ]; then
		echo " ==> Installing Oh My Zsh"
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	fi

	ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
	if [ ! -d "${ZSH_CUSTOM}/themes/spaceship-prompt" ]; then
		echo " ==> Installing Spaceship ZSH"
		git clone https://github.com/denysdovhan/spaceship-prompt.git "${ZSH_CUSTOM}/themes/spaceship-prompt"
		ln -s "${ZSH_CUSTOM}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM}/themes/spaceship.zsh-theme"
	fi

	if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
		echo " ==> Installing zsh-autosuggestions"
		git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
	fi

	if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
		echo " ==> Installing zsh-syntax-highlighting"
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
	fi

	LOCAL_BIN="${HOME}/.local/bin"
	mkdir -p "${LOCAL_BIN}"
	if [ ! -f "${LOCAL_BIN}/nvim.appimage" ]; then
		echo " ==> Installing nvim"
		curl -fLo "${LOCAL_BIN}/nvim.appimage" https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim.appimage
		chmod u+x "${LOCAL_BIN}/nvim.appimage"
	fi

	VIM_PLUG="${HOME}/.config/nvim/autoload/plug.vim"
	if [ ! -f "${VIM_PLUG}" ]; then
		echo " ==> Installing vim-plug"
		curl -fLo "${VIM_PLUG}" --create-dirs \
			https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	fi

	if [ ! -f "/etc/init.d/stackdriver-agent" ]; then
		echo " ==> Installing Stackdriver monitoring agent"
		curl -sSO https://dl.google.com/cloudagents/install-monitoring-agent.sh
		sudo bash ./install-monitoring-agent.sh
		rm ./install-monitoring-agent.sh
	fi

	if [ ! -f "/etc/init.d/google-fluentd" ]; then
		echo " ==> Installing Stackdriver logging agent"
		curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
		sudo bash ./install-logging-agent.sh
		rm ./install-logging-agent.sh
	fi
}

pip-installs() {
	echo " ==> Installing Python modules"
	pip3 install pynvim
}

go-installs() {
	GO_ARCHIVE="go${GO_VERSION}.linux-amd64.tar.gz"
	GO_ROOT="/usr/local"
	if [ ! -d "${GO_ROOT}/go" ]; then
		echo " ==> Installing Go"
		curl -fLo ${GO_ARCHIVE} \
			https://dl.google.com/go/${GO_ARCHIVE}
		sudo tar -C ${GO_ROOT} -xzf ${GO_ARCHIVE}
		rm ${GO_ARCHIVE}
	fi
}

js-installs() {
	if [ ! -f "/usr/bin/node" ]; then
		echo " ==> Installing Node.js"
		curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | sudo bash -
		sudo apt install -y nodejs
	fi

	if [ ! -f "/usr/bin/yarn" ]; then
		echo " ==> Installing yarn"
		curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
		echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
		sudo apt update && sudo apt install -y yarn && sudo apt auto-remove
	fi
}

copy-dotfiles() {
	echo " ==> Copying dotfiles"

	cp zshrc "${HOME}/.zshrc"
	cp aliases "${HOME}/.aliases"

	cp tmux.conf "${HOME}/.tmux.conf"
	cp tmux.conf.local "${HOME}/.tmux.conf.local"

	mkdir -p "${HOME}/.config/nvim"
	cp init.vim "${HOME}/.config/nvim/init.vim"
}

change-shell() {
	if [ -f "/bin/zsh" ]; then
		sudo chsh -s /bin/zsh "${USER}"
	fi
}

do-it() {
	# Update package index and upgrade packages.
	apt-upgrade
	
	# APT installs.
	apt-installs

	# Additional installs.
	additional-installs

	# Python modules installs.
	pip-installs

	# Golang installs.
	go-installs

	# Javascript installs.
	js-installs

	# Dotfiles.
	copy-dotfiles

	# ZSH.
	change-shell
}

do-it
