{ config, lib, pkgs, modulesPath, ... }:

{
  # fix issue where dotnet does not find the installed runtime; see: https://nixos.wiki/wiki/DotNET
  environment.sessionVariables = {
    # set dotnet sdk root
    DOTNET_ROOT = "${pkgs.dotnet-sdk}";

    # set AMD Vulkan driver to RADV
    AMD_VULKAN_ICD = "RADV"
  };
}
