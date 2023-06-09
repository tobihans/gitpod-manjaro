FROM manjarolinux/base:latest


RUN <<EOF
pacman -Syy --noconfirm --needed base-devel shadow git git-lfs cmake libseccomp libtool
pacman -Syy --noconfirm --needed chezmoi curl zip unzip neovim tree-sitter xclip ripgrep bottom lazygit tmux stylua bat
pacman -Syy --noconfirm --needed php composer php-apache php-cgi php-fpm php-gd  php-embed php-intl php-redis php-snmp
pacman -Syy --noconfirm --needed docker openssh github-cli
rm -f /var/cache/pacman/pkg/*
EOF

ENV LANG=en_US.UTF-8

RUN useradd -l -u 33333 -G wheel -md /home/gitpod -s /bin/bash -p gitpod gitpod

ENV HOME=/home/gitpod

WORKDIR $HOME

RUN sudo echo "gitpod ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers
# RUN sudo usermod -aG docker gitpod
# RUN sudo git lfs install --system --skip-repo

USER gitpod

RUN <<EOF
# Neovim setup
mkdir -p .config && git clone --depth 1 https://github.com/AstroNvim/AstroNvim .config/nvim
git clone --depth 1 https://github.com/tobihans/nvim-config .config/nvim/lua/user

# Bash prompt setup
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended
bash -c "$(curl -fsLS https://chezmoi.io/get)" -- init --apply https://github.com/tobihans/dotfiles.git

# SDKMAN
curl -s "https://get.sdkman.io" | bash

# Node Version Manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
bash -c ". ~/.nvm/nvm.sh && nvm install --lts && nvm use --lts && npm install -g yarn pnpm"

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
bash -c "source $HOME/.cargo/env && cargo install starship --locked"

# NVIM_UNATTENDED_INSTALLATION=true nvim --headless -c 'quitall'
EOF

WORKDIR /workspace

ENTRYPOINT [ "/bin/bash" ]
