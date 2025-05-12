{ 
  config,
  isKVM,
  lib,
  pkgs,
  ...
}: {
  swapDevices = [
    {
      device = "/dev/disk/by-label/SWAP";
    }
  ];

  fileSystems = {

    "/" = lib.mkForce {
      device = "tmpfs";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [
        "defaults"
        "size=1G"
        "mode=755"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
      neededForBoot = true;
    };

    "/persist" = {
      device = "/dev/disk/by-label/PERSIST";
      fsType = "ext4";
      options = [ "defaults" "noatime" "discard" "commit=60" "barrier=1" ];
      neededForBoot = true;
    };

    "/home" = {
      device = "/dev/disk/by-label/HOME";
      fsType = "ext4";
      options = [ "defaults" "noatime" "discard" "commit=60" "barrier=1" ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/NIX";
      fsType = "ext4";
      options = [ "defaults" "noatime" "discard" "commit=60" "barrier=1" ];
      neededForBoot = true;
    };

    "/tmp" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "size=1G"
        "mode=1777"
        "noexec"
        "nodev"
        "nosuid"
      ];
    };
  };

}
