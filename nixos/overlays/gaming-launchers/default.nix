# overlays/gaming-launchers/default.nix
self: super: {

  # Wrap Steam to run with gamemoderun
  steam = super.symlinkJoin {
    name = "steam";
    paths = [ super.steam ];
    buildInputs = [ super.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/steam --prefix PATH : ${super.lib.makeBinPath [ super.gamemode ]}
      mv $out/bin/steam $out/bin/.steam-unwrapped
      makeWrapper ${super.gamemode}/bin/gamemoderun $out/bin/steam --add-flags $out/bin/.steam-unwrapped
    '';
  };

  # Wrap Lutris (built-in support, but wrapper ensures auto-activation)
  lutris = super.symlinkJoin {
    name = "lutris";
    paths = [ super.lutris ];
    buildInputs = [ super.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/lutris --prefix PATH : ${super.lib.makeBinPath [ super.gamemode ]}
      mv $out/bin/lutris $out/bin/.lutris-unwrapped
      makeWrapper ${super.gamemode}/bin/gamemoderun $out/bin/lutris --add-flags $out/bin/.lutris-unwrapped
    '';
  };

  # Wrap Heroic Games Launcher
  heroic = super.symlinkJoin {
    name = "heroic";
    paths = [ super.heroic ];
    buildInputs = [ super.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/heroic --prefix PATH : ${super.lib.makeBinPath [ super.gamemode ]}
      mv $out/bin/heroic $out/bin/.heroic-unwrapped
      makeWrapper ${super.gamemode}/bin/gamemoderun $out/bin/heroic --add-flags $out/bin/.heroic-unwrapped
    '';
  };

  # Wrap Itch.io launcher
  itch = super.symlinkJoin {
    name = "itch";
    paths = [ super.itch ];
    buildInputs = [ super.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/itch --prefix PATH : ${super.lib.makeBinPath [ super.gamemode ]}
      mv $out/bin/itch $out/bin/.itch-unwrapped
      makeWrapper ${super.gamemode}/bin/gamemoderun $out/bin/itch --add-flags $out/bin/.itch-unwrapped
    '';
  };
}