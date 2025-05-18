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

  # https://nixos.wiki/wiki/Games
  # Adding programs.nix-ld = { enable = true; libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs; }; to your configuration to run nearly any binary by including all of the libraries used by Steam. (https://old.reddit.com/r/NixOS/comments/1d1nd9l/walking_through_why_precompiled_hello_world/)
  programs.nix-ld = { 
    enable = true;
    libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs;
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

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}