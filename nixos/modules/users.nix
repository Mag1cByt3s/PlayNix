{
  config,
  lib,
  user,
  ...
}:
{
  # silence warning about setting multiple user password options
  # https://github.com/NixOS/nixpkgs/pull/287506#issuecomment-1950958990
  options = {
    warnings = lib.mkOption {
      apply = lib.filter (
        w: !(lib.strings.hasInfix "The options silently discard others by the order of precedence" w)
      );
    };
  };

  config = lib.mkMerge [
    {
      users = {
        mutableUsers = false;
        # setup users with persistent passwords
        # https://reddit.com/r/NixOS/comments/o1er2p/tmpfs_as_root_but_without_hardcoding_your/h22f1b9/
        # create a password with for root and $user with:
        # mkpasswd -m sha-512 'PASSWORD' | sudo tee -a /persist/etc/shadow.d/root
        users = {
          root = {
            initialPassword = "password";
            hashedPasswordFile = "/persist/etc/shadow.d/root";
          };
          ${user} = {
            isNormalUser = true;
            initialPassword = "password";
            hashedPasswordFile = "/persist/etc/shadow.d/${user}";
            extraGroups = [
              "wheel"
              "sudo"
              "uucp"
              "lp"
              "adm"
              "input"
              "uinput"
              "networkmanager"
              "network"
              "audio"
              "storage"
              "video"
              "render"
              "gamemode"
              "openrazer"
            ];
          };
        };
      };
    }

    # disable sops for now
    # use sops for user passwords if enabled
    #(lib.mkIf config.custom.sops.enable (
    #  let
    #    inherit (config.sops) secrets;
    #  in
    #  {
    #    # https://github.com/Mic92/sops-nix?tab=readme-ov-file#setting-a-users-password
    #    sops.secrets = {
    #      rp.neededForUsers = true;
    #      up.neededForUsers = true;
    #    };

        # create a password with for root and $user with:
        # mkpasswd -m sha-512 'PASSWORD' and place in secrets.json under the appropriate key
    #   users.users = {
    #      root.hashedPasswordFile = lib.mkForce secrets.rp.path;
    #      ${user}.hashedPasswordFile = lib.mkForce secrets.up.path;
    #    };
    #  }
    #))
  
  
  ];
}