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
      baseXanmod = chaoticPkgs.linux_xanmod_latest.override {
        structuredExtraConfig = with lib.kernel; {
          # 1000 Hz tick rate for better desktop/gaming responsiveness
          HZ = freeform "1000";
          HZ_1000 = yes;
          HZ_250 = no;

          # Zen 3 optimizations for Ryzen 7 5800X (-march=znver3)
          MZEN3 = yes;
          GENERIC_CPU = no;

          # AMD P-State support (ties into our active mode and EPP=performance)
          X86_AMD_PSTATE = yes;
          ACPI_CPPC_LIB = yes;  # Required for CPB and full P-State features

          # sched-ext class for LAVD/SCX support
          SCHED_CLASS_EXT = yes;

          # Enable NTSync for Wine/Proton compatibility/performance
          NTSYNC = yes;

          # Enable full LTO with Clang for maximum optimization
          LTO_CLANG = yes;
          LTO_CLANG_FULL = yes;  # Aggressive full LTO (use LTO_CLANG_THIN = yes; for faster builds if needed)
        };
        ignoreConfigErrors = true;  # Skip minor config warnings during build
      };
      # set custom compile flags
      myCustomXanmod = baseXanmod.overrideAttrs (old: {
        stdenv = pkgs.clangStdenv;  # Switch to Clang for LTO support
        # set custom GCC compiler flags
        NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -march=native -O3 -pipe";
      });
    in pkgs.linuxPackagesFor myCustomXanmod;  # Use pkgs.linuxPackagesFor to generate the full package set

    # Initramfs settings
    initrd = {
      # enable stage-1 bootloader
      systemd.enable = true;

      # Enable EXT4 filesystem support
      supportedFilesystems = [ "ext4" ];
    };

    # Enable EXT4 filesystem support
    supportedFilesystems = [ "ext4" ];

    # Clear /tmp on boot
    tmp.cleanOnBoot = true;

    # Enable Plymouth
    plymouth = {
      enable = true;
      theme = "bgrt";
    };

    # Bootloader settings
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

  # Fix bug that bootloader entry name cannot be set via boot.loader.grub.configurationName
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