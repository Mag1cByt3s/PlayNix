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
  };
}