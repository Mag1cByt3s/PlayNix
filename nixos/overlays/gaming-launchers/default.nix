# overlays/gaming-launchers/default.nix
self: super: {
  # Helper function to wrap a package with gamemoderun
  wrapWithGamemode = { pkg, binName }: super.symlinkJoin {
    name = pkg.name or binName;
    paths = [ pkg ];
    buildInputs = [ super.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/${binName} --prefix PATH : ${super.lib.makeBinPath [ super.gamemode ]}
      mv $out/bin/${binName} $out/bin/.${binName}-unwrapped
      makeWrapper ${super.gamemode}/bin/gamemoderun $out/bin/${binName} --add-flags $out/bin/.${binName}-unwrapped
    '';
  };

  # Wrap Steam to run with gamemoderun, preserving overridability and 'run' attribute
  steam = let
    wrapped = self.wrapWithGamemode { pkg = super.steam; binName = "steam"; };
  in wrapped // {
    run = super.steam.run;
    override = args: let
      overridden = super.steam.override args;
      wrappedOverridden = self.wrapWithGamemode { pkg = overridden; binName = "steam"; };
    in wrappedOverridden // {
      run = overridden.run;
    };
  };

  # Wrap Lutris
  lutris = self.wrapWithGamemode { pkg = super.lutris; binName = "lutris"; };

  # Wrap Heroic Games Launcher
  heroic = self.wrapWithGamemode { pkg = super.heroic; binName = "heroic"; };

  # Wrap Itch.io launcher
  itch = self.wrapWithGamemode { pkg = super.itch; binName = "itch"; };
}