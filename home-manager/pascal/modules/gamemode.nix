{ config, lib, pkgs, ... }:

{
  xdg.desktopEntries.steam-gamemode = {
    name = "Steam (GameMode)";
    genericName = "";
    exec = "${pkgs.gamemode}/bin/gamemoderun steam -forcedesktopscaling=1.8 %U";
    icon = "steam";
    type = "Application";
    categories = [ "X-games" ];
  };
}
