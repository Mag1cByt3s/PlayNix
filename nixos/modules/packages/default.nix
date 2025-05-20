# packages

{ inputs, config, lib, pkgs, modulesPath, ... }:

{
  # disable default packages
  environment.defaultPackages = [];

  imports = [
    # General programs
    ./general.nix

    # NixOS related programs
    ./nixos.nix

    # Version Control Systems
    ./vcs.nix

    # Code editors
    ./editors.nix

    # Web browsers
    ./browsers.nix

    # Chat programs
    ./chat.nix

    # Development oriented tools
    ./dev.nix

    # Multimedia programs
    ./multimedia.nix

    # Office programs
    ./office.nix

    # SMB tools
    ./smb.nix

    # Remote Access programs
    ./remote-access.nix

    # Wine
    ./wine.nix

    # Programs for file transfer
    ./file-transfer.nix

    # Gaming related programs
    #./gaming.nix
  ];
}
