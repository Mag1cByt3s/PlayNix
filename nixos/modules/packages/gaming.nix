{ inputs, config, lib, pkgs, modulesPath, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
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
  ];
}
