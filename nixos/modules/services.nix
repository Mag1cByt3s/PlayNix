{ config, lib, pkgs, modulesPath, ... }:

{
  # Disable power-profiles-daemon (interferes with cpufreq)
  services.power-profiles-daemon.enable = lib.mkForce false;

  # Fwupd settings
  services.fwupd = {
    enable = true;
  };

  # Pipewire settings
  # Disable Pulseaudio
  services.pulseaudio.enable = false;
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  # Enable Pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # TRIM settings
  # Enable periodic TRIM
  services.fstrim.enable = true;

  # DBus settings
  # Enable DBus
  services.dbus.enable = true;
  # use dbus broker as the default implementation
  services.dbus.implementation = "broker";

  # Enable timesyncd
  services.timesyncd.enable = true;

  # Enable profile-sync-daemon
  services.psd = {
    enable = true;
    resyncTimer = "30min";
  };

  # Enable Flatpak support
  services.flatpak.enable = true;

   # Make nixos boot slightly faster by turning these off during boot
  systemd.services.NetworkManager-wait-online.enable = false;

  # Enable LACT
  services.lact.enable = true;

  # Schedulers from https://wiki.archlinux.org/title/improving_performance
  services.udev.extraRules = ''
    # Needed for ZFS. Otherwise the system can freeze
    ACTION=="add|change", KERNEL=="sd[a-z]*[0-9]*|mmcblk[0-9]*p[0-9]*|nvme[0-9]*n[0-9]*p[0-9]*", ENV{ID_FS_TYPE}=="zfs_member", ATTR{../queue/scheduler}="none"
    # HDD
    ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
    # SSD
    ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"
    # NVMe SSD
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"
  '';

}
