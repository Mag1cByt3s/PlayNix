{ config, pkgs, lib, ... }:

{
  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true; # Enable Gamescope session
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