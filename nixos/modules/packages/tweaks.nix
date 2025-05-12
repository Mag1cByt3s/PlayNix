{ config, lib, pkgs, modulesPath, ... }:

{
  # fix issue where dotnet does not find the installed runtime; see: https://nixos.wiki/wiki/DotNET
  environment.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk}";
  };
}
