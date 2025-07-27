{ 
  config,
  isKVM,
  lib,
  pkgs,
  chaoticPkgs,
  modulesPath,
  ... 
}: {
  boot = {
    # Set kernel parameters
    kernelParams = [
      "quiet"
      "splash"
      "nohibernate"
      "elevator=none"
      "fsck.mode=auto"
      "loglevel=0"
      "rd.systemd.show_status=false"
      "nowatchdog"
      "kernel.nmi_watchdog=0"
      "mitigations=off"
      "libahci.ignore_sss=1"
      "modprobe.blacklist=iTCO_wdt"
      "modprobe.blacklist=sp5100_tco"
      "processor.ignore_ppc=1"
      "sysrq_always_enabled=1"
      "split_lock_detect=off"
      "consoleblank=0"
      "audit=0"
      "net.ifnames=0"
      "biosdevname=0"
      "pcie_aspm.policy=performance"
      "amd_pstate=active"
    ];

    # Custom Xanmod kernel override
    kernelPackages = let
      myCustomXanmod = chaoticPkgs.linux_xanmod_latest.override {
        structuredExtraConfig = with lib.kernel; {
          # 1000 Hz tick rate for better desktop/gaming responsiveness
          HZ = freeform "1000";
          HZ_1000 = yes;
          HZ_250 = no;

          # x86_64-v3 optimizations for your Ryzen 7 5800X (Zen 3)
          MX86_64_V3 = yes;
          GENERIC_CPU = no;

          # AMD P-State support (ties into our active mode and EPP=performance)
          X86_AMD_PSTATE = yes;

          # sched-ext class for LAVD/SCX support
          SCHED_CLASS_EXT = yes;

          # Preserve Xanmod's key tweaks (e.g., performance governor, BBRv3, full preemption)
          # These are already set in the base config, but we can reinforce if needed
          CPU_FREQ_DEFAULT_GOV_PERFORMANCE = mkOverride 60 yes;
          CPU_FREQ_DEFAULT_GOV_SCHEDUTIL = mkOverride 60 no;
          PREEMPT = mkOverride 60 yes;
          PREEMPT_VOLUNTARY = mkOverride 60 no;
          TCP_CONG_BBR = yes;
          DEFAULT_BBR = yes;
          RCU_EXPERT = yes;
          RCU_FANOUT = freeform "64";
          RCU_FANOUT_LEAF = freeform "16";
          RCU_BOOST = yes;
          RCU_BOOST_DELAY = freeform "0";
          RCU_EXP_KTHREAD = yes;
        };
        ignoreConfigErrors = true;  # Skip minor config warnings during build
      };
    in pkgs.linuxPackagesFor myCustomXanmod;  # Use pkgs.linuxPackagesFor to generate the full package set

    # Initramfs settings (unchanged)
    initrd = {
      # enable stage-1 bootloader
      systemd.enable = true;

      # Enable EXT4 filesystem support
      supportedFilesystems = [ "ext4" ];
    };

    # Enable EXT4 filesystem support (unchanged)
    supportedFilesystems = [ "ext4" ];

    # Clear /tmp on boot (unchanged)
    tmp.cleanOnBoot = true;

    # Enable Plymouth (unchanged)
    plymouth = {
      enable = true;
      theme = "bgrt";
    };

    # Bootloader settings (unchanged)
    loader = {
      systemd-boot.enable = false;

      timeout = 3;

      # EFI settings
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      # Enable Grub Bootloader
      grub = {
        enable = true;

        copyKernels = true;

        efiSupport = true;
        devices = [ "nodev" ];
        useOSProber = true;
        fontSize = 24;

        # Use Dark Matter GRUB Theme
        darkmatter-theme = {
          enable = true;
          style = "nixos";
          icon = "color";
          resolution = "1440p";
        };
      };
    };
  };

  # Fix bug that bootloader entry name cannot be set via boot.loader.grub.configurationName (unchanged)
  # see: https://github.com/NixOS/nixpkgs/issues/15416
  system.activationScripts.update-grub-menu = {
    text = ''
      echo "Updating GRUB menu entry name..."

      GRUB_CFG="/boot/grub/grub.cfg"
      BACKUP_GRUB_CFG="/boot/grub/grub.cfg.bak"
      SEARCH_STR="\"NixOS"
      REPLACE_STR="\"PlayNix"

      if [ -f "$GRUB_CFG" ]; then
          cp "$GRUB_CFG" "$BACKUP_GRUB_CFG"
          ${pkgs.gnused}/bin/sed -i "s/$SEARCH_STR/$REPLACE_STR/g" "$GRUB_CFG"
      else
          echo "Error: GRUB configuration file not found."
      fi
    '';
  };
}