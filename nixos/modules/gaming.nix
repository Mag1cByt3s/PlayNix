{ 
  config,
  inputs,
  pkgs,
  lib,
  chaotic,
  modulesPath,
  ...
}: let 
  gaming = inputs.nix-gaming;
in {
  imports = with gaming.nixosModules; [
    # https://github.com/fufexan/nix-gaming#platform-optimizations
    pipewireLowLatency
    platformOptimizations
  ];

  # Switch to mesa-git
  #chaotic.mesa-git.fallbackSpecialisation = lib.mkForce false;
  #chaotic.mesa-git.enable = lib.mkForce true;

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true; # Enable Gamescope session

    extraCompatPackages = with pkgs; [
      proton-ge-bin # Enable Proton-GE
    ];
  };

  # https://nixos.wiki/wiki/Games
  # Adding programs.nix-ld = { enable = true; libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs; }; to your configuration to run nearly any binary by including all of the libraries used by Steam. (https://old.reddit.com/r/NixOS/comments/1d1nd9l/walking_through_why_precompiled_hello_world/)
  # FIX: error: expected a set but found a list: https://discourse.nixos.org/t/programs-nix-ld-libraries-expects-set-instead-of-list/56009/3?utm_source=chatgpt.com
  programs.nix-ld = { 
    enable = true;
    libraries = pkgs.steam-run.args.multiPkgs pkgs;
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

  # see https://github.com/fufexan/nix-gaming/#pipewire-low-latency
  services.pipewire.lowLatency.enable = true;

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    WINENTSYNC = "1";  # Enable ntsync for best compatibility/performance
    WINEESYNC = "0";   # Disable esync to avoid conflicts
    WINEFSYNC = "0";   # Disable fsync to avoid conflicts
  };
}