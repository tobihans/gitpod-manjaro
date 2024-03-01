FROM manjarolinux/base:latest

ENV LANG=en_US.UTF-8

RUN pacman -Syu git --noconfirm
RUN rm -f /var/cache/pacman/pkg/*
RUN useradd -l -u 33333 -G wheel -md /home/gitpod -s /bin/bash -p gitpod gitpod
RUN <<EOF
mkdir -p /etc/sudoers.d/
echo "gitpod  ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/gitpod
chmod 0440 /etc/sudoers.d/gitpod
EOF

ENV HOME=/home/gitpod

WORKDIR $HOME

USER gitpod

RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/tobihans/dotfiles.git

# TODO: Remove cached packages once done

WORKDIR /workspace

ENTRYPOINT [ "/bin/bash" ]
