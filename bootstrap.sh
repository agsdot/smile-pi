#!/usr/bin/env bash

if ( ! grep -q 'archlinuxfr' /etc/pacman.conf )
then

echo "add server for yaourt"
echo "
[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/\$arch
" >> /etc/pacman.conf

fi

pacman -Syu
pacman -S --noconfirm --needed --force vim git wget base-devel

sed -i '/wheel ALL/s/^#//g' /etc/sudoers
