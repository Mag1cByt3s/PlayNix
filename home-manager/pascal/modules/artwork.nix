{ config, lib, pkgs, inputs, ... }:

let
  wallpaperPath = ../../../../assets/wallpapers;
in
{
  home.file.".local/share/wallpapers/playnix/" = {
    source = wallpaperPath;
    recursive = true;
    force = true;
  };
}
