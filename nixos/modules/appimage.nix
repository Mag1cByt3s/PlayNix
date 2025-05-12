{ config, pkgs, lib, ... }:

{
  # Some games may distribute on Linux as an AppImage. To get them to execute via Steam, enable AppImage with the binfmt setting:
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}