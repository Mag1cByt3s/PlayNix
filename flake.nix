{
  description = "PlayNix";

  nixConfig = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      extra-substituters = [
        "https://nyx.chaotic.cx"
        "https://nix-community.cachix.org/"
        "https://cache.nixos.org/"
      ];
      extra-trusted-public-keys = [
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
  };

  inputs = {
    # Nixpkgs-Unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Chaotic's Nyx
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Modules support for flakes
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Have a local index of nixpkgs for fast launching of apps
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home configuration management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/pjones/plasma-manager
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Easy linting of the flake and all kind of other stuff
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.flake-compat.follows = "nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    # https://gitlab.com/VandalByte/darkmatter-grub-theme
    darkmatter-grub-theme = {
      url = gitlab:VandalByte/darkmatter-grub-theme;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/nix-community/impermanence
    impermanence = {
      url = "github:nix-community/impermanence";
    };

    # https://github.com/NixOS/nixos-hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Nix Gaming for Steam platformOptimizations
    # https://github.com/fufexan/nix-gaming
    nix-gaming.url = "github:fufexan/nix-gaming";
  };

  outputs = { 
      self, 
      nixpkgs,
      impermanence,
      chaotic, 
      flake-parts, 
      pre-commit-hooks, 
      home-manager, 
      plasma-manager, 
      darkmatter-grub-theme,
      nixos-hardware,
      nix-gaming,
      ...
  } @ inputs: let
      inherit (self) outputs;
      system = "x86_64-linux";
  in {
      nixosConfigurations = {
            
          # battlestation nixos host config
          battlestation = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit inputs outputs;
              chaoticPkgs = import inputs.nixpkgs {
                inherit system;
                overlays = [ inputs.chaotic.overlays.default ];
                config.allowUnfree = true;
              };
              user = "pascal";
              isKVM = false;
            };
            modules = [
              darkmatter-grub-theme.nixosModule
              inputs.impermanence.nixosModules.impermanence
              (import "${inputs.nixos-hardware}/asus/rog-strix/x570e")
              (import "${inputs.nixos-hardware}/common/gpu/amd")
              (import "${inputs.nixos-hardware}/common/hidpi.nix")

              ./nixos/hosts/battlestation
              {
                imports = [ inputs.home-manager.nixosModules.home-manager ];

                home-manager.useGlobalPkgs = false;
                home-manager.useUserPackages = true;

                home-manager.extraSpecialArgs = { 
                  inherit inputs;
                  user = "pascal";
                  pkgs = import inputs.nixpkgs {
                    system = "x86_64-linux";
                    config.allowUnfree = true;
                    overlays = [
                      
                    ];
                  };
                };

                home-manager.users = {
                  pascal = {
                    home.username = "pascal";
                    home.homeDirectory = "/home/pascal";
                    home.stateVersion = "23.05";
                    imports = [
                      ./home-manager/pascal
                    ];
                  };
                };
              }
            ];
          };

    };
  };
}
