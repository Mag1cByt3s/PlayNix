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

    # Switch to Zen Kernel
    kernelPackages = pkgs.linuxPackages_zen;

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