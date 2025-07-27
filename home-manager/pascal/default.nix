# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ 
  inputs,
  lib,
  config,
  pkgs,
  user,
  chaoticPkgs,
  ... 
}: let
  # Clean pkgs for home-manager
  homePkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true; # Optional
  };
in {
  # import other home-manager modules
  imports = [
    inputs.nur.modules.homeManager.default
    inputs.plasma-manager.homeManagerModules.plasma-manager
    ./modules/git.nix
    ./modules/dconf.nix
    ./modules/theme.nix
    ./modules/artwork.nix
    ./modules/zsh.nix
    ./modules/plasma-manager.nix
    ./modules/kwallet.nix
    ./modules/konsole.nix
    ./modules/dolphin.nix
    ./modules/firefox.nix
    ./modules/psd.nix
    ./modules/flatpak.nix
    ./modules/xdg.nix
    ./modules/ssh-agent.nix
    ./modules/packages.nix
  ];

  # Pass homePkgs to all imported modules
  _module.args = {
    inherit homePkgs;
  };

  home = {
    # set username
    username = "${user}";

    # set home directory
    homeDirectory = "/home/${user}";

    # do not change this value!
    stateVersion = "23.05";

    # disable warning about mismatched version between Home Manager and Nixpkgs
    enableNixpkgsReleaseCheck = false;

    # set user session variables
    sessionVariables = {
      # This should be default soon
      MOZ_ENABLE_WAYLAND = 1;

      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
    };
  };

  # enable xsession
  xsession.enable = true;

  # this is required for NixOS home-manager to work!
  # let NixOS manage home-manager
  programs.home-manager.enable = false;
}
