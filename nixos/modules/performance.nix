{ config, lib, pkgs, modulesPath, ... }:

{
    powerManagement = {
        enable = lib.mkForce true;
        cpuFreqGovernor = lib.mkDefault "performance";
        powertop.enable = lib.mkForce false;
    };

    services.tlp = {
      enable = lib.mkForce false;
    };

    # Set EPP to performance (0) at boot or runtime
    systemd.services.set-epp = {
      description = "Set AMD P-State EPP to Performance";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c 'for policy in /sys/devices/system/cpu/cpufreq/policy*; do echo performance > $policy/energy_performance_preference; done'";
      };
    };
}