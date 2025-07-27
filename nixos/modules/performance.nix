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

    # Fallback systemd service to globally enable CPB at boot (since we are not using power-profiles-daemon)
    systemd.services.enable-cpb = {
      description = "Enable AMD Core Performance Boost on All Cores";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c 'echo 1 | tee /sys/devices/system/cpu/cpu*/cpufreq/boost'";
      };
    };

    # Enable LAVD scheduler via NixOS's scx module
    services.scx = {
      enable = true;
      scheduler = "scx_lavd";
      # Optional: Customize mode/args for gaming performance
      extraOptions = [
        "--performance"  # Bias toward low latency (gaming-focused)
        "--core-compaction"  # Explicitly enable power-saving compaction
      ];
    };

    # Disable conflicting services (e.g., ananicy-cpp)
    services.ananicy.enable = lib.mkForce false;  # Avoid priority conflicts with LAVC scx scheduler
}