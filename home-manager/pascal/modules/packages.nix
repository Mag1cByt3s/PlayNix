{ 
  config,
  lib,
  pkgs,
  homePkgs,
  chaoticPkgs,
  ...
}: {
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
    ludusavi

    # wine
    winetricks
    wineWow64Packages.waylandFull
    bottles
    chaoticPkgs.proton-cachyos_x86_64_v3
  ];
}
