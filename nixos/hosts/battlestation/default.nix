# NixOS hosts config for my Battlestation
{ 
  config,
  lib,
  pkgs,
  chaotic,
  chaoticPkgs,
  inputs,
  isKVM,
  ...
}: {
  # Import other NixOS modules here
  imports = [
    # Nix configuration
    ../../modules/nix.nix

    # Nixpkgs configuration
    ../../modules/nixpkgs.nix

    # Additional hardware configuration for battlestation
    ./hardware.nix

    # Filesystems configuration
    ../../modules/filesystems.nix

    # Impermanence configuration
    ../../modules/impermanence.nix

    # Bootloader configuration
    ../../modules/bootloader.nix

    # Networking configuration
    ../../modules/networking.nix

    # System packages
    ../../modules/packages

    # Sysctl settings
    ../../modules/sysctl.nix

    # User settings
    ../../modules/users.nix

    # Shell settings
    ../../modules/setup-shell.nix

    # Services settings
    ../../modules/services.nix

    # KDE settings
    ../../modules/kde.nix

    # Security settings
    ../../modules/security.nix

    # performance optimizations
    ../../modules/performance.nix

    # XDG settings
    ../../modules/xdg.nix

    # apply various system tweaks which are required for red-flake to work
    ../../modules/tweaks.nix

    # SSH settings
    ../../modules/ssh.nix

    # AppImage settings
    ../../modules/appimage.nix

    # Gaming related settings
    ../../modules/gaming.nix
  ];

  # Set hostname
  networking.hostName = "battlestation";

  # Set fixed hostId
  networking.hostId = "def91f5a";

  # Set timezone
  time.timeZone = "Europe/Berlin";

  # Set locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Set extra locale settings
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    # week starts on a Monday
    LC_TIME = "en_GB.UTF-8";
  };

  # Do not modify this value
  system.stateVersion = "23.05";

}
