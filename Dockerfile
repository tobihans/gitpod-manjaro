FROM manjarolinux/base:latest


RUN pacman -Syy --noconfirm --needed \
    base-devel \
    shadow \
    git \
    git-lfs \
    cmake \
    libseccomp \
    libtool \
    chezmoi \
    curl \
    zip \
    unzip

# Neovim setup
RUN pacman -Syy --noconfirm --needed \
  neovim \
  tree-sitter \
  xclip \
  ripgrep \
  bottom \
  lazygit \
  tmux

# Cleanup
RUN rm -f /var/cache/pacman/pkg/*

ENV LANG=en_US.UTF-8

RUN useradd -l -u 33333 -G wheel -md /home/gitpod -s /bin/bash -p gitpod gitpod

ENV HOME=/home/gitpod

ENV NVIM_UNATTENDED_INSTALLATION=true

WORKDIR $HOME

RUN sudo echo "gitpod ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

RUN sudo git lfs install --system

USER gitpod

RUN mkdir -p .config && git clone --depth 1 https://github.com/AstroNvim/AstroNvim .config/nvim

RUN git clone --depth 1 https://github.com/tobihans/nvim-config .config/nvim/lua/user

RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended
RUN sh -c "$(curl -fsLS https://chezmoi.io/get)" -- init https://github.com/tobihans/dotfiles.git
RUN curl -s "https://get.sdkman.io" | bash
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# RUN nvim --headless -c 'autocmd User LazyDone quitall'

ENTRYPOINT [ "/bin/bash" ]