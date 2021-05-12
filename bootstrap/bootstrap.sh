#!/usr/bin/env bash

set -eu

export DEBIAN_FRONTEND=noninteractive

DELTA_VERSION="0.7.1"
GO_VERSION="1.16"
NODE_VERSION="16"
NVIM_VERSION="0.4.4"

apt-upgrade() {
    echo " ==> Upgrading packages"
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get auto-remove -y
}

apt-installs() {
    echo " ==> Installing base packages"
    sudo apt-get update
    sudo apt-get install -y \
        fzf \
        git \
        htop \
        iftop \
        jq \
        mosh \
        prettyping \
        python3 \
        python3-pip \
        ranger \
        ripgrep \
        tmux \
        unzip \
        zsh
    sudo apt-get auto-remove -y
}

additional-installs() {
    if [ ! -d "${HOME}/.oh-my-zsh" ]; then
        echo " ==> Installing Oh My Zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    if [ ! -f "/usr/local/bin/starship" ]; then
        echo " ==> Installing Starship"
        curl -fsSL https://starship.rs/install.sh | bash -s -- -f
    fi

    ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
    if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
        echo " ==> Installing zsh-autosuggestions"
        git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
    fi

    if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
        echo " ==> Installing zsh-syntax-highlighting"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
    fi

    if [ ! -f "/usr/bin/delta" ]; then
        echo " ==> Installing git-delta"
        curl -sLO "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb"
        sudo dpkg -i ./git-delta_${DELTA_VERSION}_amd64.deb
        rm ./git-delta_${DELTA_VERSION}_amd64.deb
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

    TPM="${HOME}/.tmux/plugins/tpm"
    if [ ! -d "${TPM}" ]; then
        echo " ==> Installing tpm"
        git clone https://github.com/tmux-plugins/tpm "${TPM}"
    fi

    TFENV="${HOME}/.tfenv"
    if [ ! -d "${TFENV}" ]; then
        echo " ==> Installing tfenv"
        git clone https://github.com/tfutils/tfenv.git ~/.tfenv
    fi

    if [ ! -d "/etc/google-cloud-ops-agent" ]; then
        echo " ==> Installing Ops Agent"
        curl -fsSL https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh | sudo bash -s -- --also-install
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
        sudo apt-get install -y nodejs
    fi

    if [ ! -f "/usr/bin/yarn" ]; then
        echo " ==> Installing yarn"
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
        sudo apt-get update && sudo apt-get install -y yarn && sudo apt-get auto-remove
    fi
}

copy-dotfiles() {
    echo " ==> Copying dotfiles"

    cp config/zsh/zshrc "${HOME}/.zshrc"
    cp config/aliases/aliases "${HOME}/.aliases"

    cp config/tmux/tmux.conf "${HOME}/.tmux.conf"

    cp config/git/gitalias.txt "${HOME}/.gitalias.txt"
    cp config/git/gitconfig "${HOME}/.gitconfig"

    mkdir -p "${HOME}/.config/nvim"
    cp -r config/nvim/* "${HOME}/.config/nvim/"
}

change-shell() {
    echo " ==> Changing the shell to ZSH"

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
