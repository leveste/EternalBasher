Currently work in progress

Instructions
=========

To install QuickBMS on Linux, you can download the source code. Once downloaded, unzip the file.

Go into the *src* folder and, from terminal, run the "make" command. You might be required to install additional packages beforehand. You can look into the distro specific section for further information.

## Debian systems

If you are using Debian or a Debian based distro(Ubuntu, Mint, Pop\_OS, etc), you'll need to install the following packages beforehand:

    sudo apt install gcc g++ zlib1g-dev libssl-dev unicode gcc-multilib g++-multilib

In case of problems on 64-bit versions of Linux, you can also run the command below:

    sudo apt install libssl-dev:i386

You should now have in your **src** folder a file named **quickbms** that you can run from terminal with:

    ./quickbms [options] <instructions>

The path to the src folder is the one you'll need to type when prompted by the script.

## Arch Linux

If you are using Arch or an Arch-based distro(like Manjaro), you can find quickbms on [AUR.](https://aur.archlinux.org/packages/quickbms/)

You might have to manually install dependencies with pacman.

    sudo pacman -S bzip2 lib32-bzip2 lib32-gcc-libs lib32-lzo lib32-openssl lib32-zlib lzo openssl zlib gcc-multilib

Then simply download the package and follow standard AUR installation process.

    tar xf quickbms.tar.gz
	cd quickbms
	makepkg -si

Alternatively, if you use an AUR helper like yay, you can install the package and it's dependencies in one go.

    yay -S quickbms

The path you'll need to type when prompet should be:

    /usr/bin/quickbms