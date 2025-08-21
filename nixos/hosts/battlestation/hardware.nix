# additional hardware config
{ 
  config,
  lib,
  pkgs,
  inputs,
  ... 
}: {
  boot.kernelModules = [ 
    "i2c-dev"
    "i2c-piix4"
    "amd_pstate_epp"
  ];

  hardware = {
    # enable firmware with a license allowing redistribution
    enableRedistributableFirmware = lib.mkForce true;

    # enable all firmware regardless of license
    enableAllFirmware = lib.mkForce true;

    # enable CPU microcode updates
    cpu.amd.updateMicrocode = lib.mkForce true;

    # enable non-root access to qmk firmware
    keyboard.qmk.enable = lib.mkForce true;

    # enable openrazer
    openrazer.enable = lib.mkForce true;

    # for LACT: it is recommended to enable overdrive mode
    # see LACT wiki for more information: https://github.com/ilya-zlobintsev/LACT/wiki/Overclocking-(AMD)
    amdgpu.overdrive.enable = true;
  };

  # enable CoolerControl
  # https://docs.coolercontrol.org/installation/nix.html
  programs.coolercontrol.enable = true;
}