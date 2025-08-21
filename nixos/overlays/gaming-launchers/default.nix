# overlays/gaming-launchers/default.nix
self: super: let
  wrapWithGamemodePreserve = { pkg, binName }: let
    wrapped = super.symlinkJoin {
      name = pkg.name or binName;
      paths = [ pkg ];
      buildInputs = [ super.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/${binName} --prefix PATH : ${super.lib.makeBinPath [ super.gamemode ]}
        mv $out/bin/${binName} $out/bin/.${binName}-unwrapped
        makeWrapper ${super.gamemode}/bin/gamemoderun $out/bin/${binName} --add-flags $out/bin/.${binName}-unwrapped
      '';
    };
  in
    wrapped // {
      # Preserve override attributes
      override = args: wrapWithGamemodePreserve { pkg = pkg.override args; binName = binName; };
      overrideAttrs = f: wrapWithGamemodePreserve { pkg = pkg.overrideAttrs f; binName = binName; };
    };
in {
  # Wrap Lutris
  lutris = wrapWithGamemodePreserve { pkg = super.lutris; binName = "lutris"; };

  # Wrap Heroic Games Launcher
  heroic = wrapWithGamemodePreserve { pkg = super.heroic; binName = "heroic"; };

  # Wrap Itch.io launcher
  itch = wrapWithGamemodePreserve { pkg = super.itch; binName = "itch"; };
}
