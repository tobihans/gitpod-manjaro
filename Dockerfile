FROM manjarolinux/base:latest

ENV LANG=en_US.UTF-8

RUN useradd -l -u 33333 -G wheel -md /home/gitpod -s /bin/bash -p gitpod gitpod

ENV HOME=/home/gitpod

WORKDIR $HOME

RUN sudo echo "gitpod ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers
RUN sudo usermod -aG docker gitpod
RUN sudo git lfs install --system --skip-repo

USER gitpod

RUN bash -c "$(curl -fsLS https://chezmoi.io/get)" -- init --apply https://github.com/tobihans/dotfiles.git
RUN rm -f /var/cache/pacman/pkg/*

WORKDIR /workspace

ENTRYPOINT [ "/bin/bash" ]
