{ 
  config,
  inputs,
  pkgs,
  lib,
  chaotic,
  chaoticPkgs,
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
      chaoticPkgs.proton-cachyos_x86_64_v3
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
    RADV_FORCE_VRS = "1x2";  # Set to 1x2 (or 2x1 as an alternative). This enables Variable Rate Shading in one direction for a good perf boost (~5–15% FPS in demanding games like Cyberpunk 2077) with less shadow quality loss than 2x2. 2x2 is more aggressive but can cause noticeable artifacts in shadows/flat areas
    RADV_DEBUG = "novrsflatshading";  # Enable this to disable VRS on flat shading, preventing visual bugs. It's recommended when using RADV_FORCE_VRS to avoid artifacts in games with flat-shaded elements (e.g., UI or certain textures).
    RADV_PERFTEST = "nggc,sam,gpl";   # nggc: Enable Next-Gen Geometry Culling for a slight perf improvement (~1–5% in geometry-heavy scenes) on RX 6000 series;    sam: Force Smart Access Memory (Resizable BAR). This can improve perf (~5–10% in VRAM-bound games) if enabled in your BIOS (check with lspci -v | grep BAR);     gpl: Enable Graphics Pipeline Library for Windows-like shader caching behavior, reducing stutter in games that compile shaders on-the-fly. High load times initially (as it disables traditional caching), but worth it for smoothness in titles like Elden Ring. Requires Mesa 23+ (assume you have it; check glxinfo | grep Mesa).
  };
}