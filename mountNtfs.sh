#!/usr/bin/env bash
#! autor: j.francisco.o.rocha@gmail.com
#! 2008

ntfsfix /dev/sda1
ntfsfix /dev/sda2
mount -t ntfs-3g /dev/sda1 /media/WINXP -o force
mount -t ntfs-3g /dev/sda2 /media/Dados -o force
