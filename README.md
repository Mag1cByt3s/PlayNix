[![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-informational?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)
&ensp;
[![Nix](https://img.shields.io/badge/Nix-5277C3?logo=nixos&style=flat-square&logoColor=fff)](#)
&ensp;
[![Home-Manager Master](https://img.shields.io/badge/home_manager-master-blue?style=flat-square)](#)
&ensp;
[![KDE Plasma 6](https://img.shields.io/badge/KDE_Plasma-6-blue?style=flat-square)](#)

<br><br>

<h1 align="center">
   PlayNix
</h1>

A NixOS flake tailored for gaming. Native, Wine / Proton, optimized.

<br><br><br>

# Installation

<br>

1. Bootup any NixOS live CD
2. Install PlayNix Flake (run as root, do not use sudo):

```bash
bash <(curl -L https://raw.githubusercontent.com/Mag1cByt3s/PlayNix/main/install.sh)
```

<br><br>

# Rebuilding

<br>

Rebuild the already installed system from the flake

```bash
playnix-rebuild
```

<br><br>

# Features

<br>

- custom NixOS flake using NixOS unstable
- NixOS home-manager
- root on EXT4
- Impermanence (non-persistent root on tmpfs) with persistence on `/persist`
- GRUB bootloader with EFI support & theme
- performance tweaks
- customized KDE desktop
- customized KDE start menu
- pre-configured system for gaming
- customized zsh shell with oh-my-zsh
- provide automatic provisioning for
   - Zsh
   - KDE Plasma
   - Firefox
   - ... and more

<br><br>

# Contributing

Community contributions are always welcome through GitHub Issues and
Pull Requests.

<br><br>

# License

PlayNix is licensed under the [GPL License](LICENSE).
