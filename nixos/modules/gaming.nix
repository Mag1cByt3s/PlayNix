{ 
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  # Switch to mesa-git
  chaotic.mesa-git.enable = lib.mkForce true;

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true; # Enable Gamescope session

    # https://github.com/fufexan/nix-gaming#platform-optimizations
    # A bunch of optimizations for Steam from SteamOS
    platformOptimizations.enable = true;
  };

  # Enable Gamescope Compositor
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # Enable GameMode
  programs.gamemode = {
    enable = true;
  };
}