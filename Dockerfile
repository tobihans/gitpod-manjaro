FROM manjarolinux/base:latest

ENV LANG=en_US.UTF-8

RUN useradd -l -u 33333 -G wheel -md /home/gitpod -s /bin/bash -p gitpod gitpod

ENV HOME=/home/gitpod

WORKDIR $HOME

USER gitpod

RUN pacman -S git --noconfirm
RUN rm -f /var/cache/pacman/pkg/*

WORKDIR /workspace

ENTRYPOINT [ "/bin/bash" ]
