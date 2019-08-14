FROM archlinux/base

RUN pacman -Syu --noconfirm
RUN pacman -S sudo base base-devel binutils --needed --noconfirm
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN useradd build -G wheel -m
