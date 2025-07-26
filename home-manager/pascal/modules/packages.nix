{ config, lib, pkgs, homePkgs, ... }: 

{
# set user packages
  home.packages = with homePkgs; [
    papirus-icon-theme
    bibata-cursors
    sweet-nova
    oh-my-zsh
    zsh-autosuggestions
    zsh-completions
    nix-zsh-completions
    zsh-syntax-highlighting
    zsh-powerlevel10k
    meslo-lgs-nf
    flatpak

    # gaming related package
    mangohud
    steam-run
    steamtinkerlaunch
    steam-rom-manager
    umu-launcher
    protonup-qt
    protonup-ng
    lutris
    heroic
    itch

    # wine
    winetricks
    wineWow64Packages.waylandFull
    bottles
  ];
}
