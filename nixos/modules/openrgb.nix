{ 
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}: {
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];

  services.udev.extraRules = (builtins.readFile "${pkgs.openrgb}/lib/udev/rules.d/60-openrgb.rules");

  services.hardware.openrgb = { 
    enable = true; 
    package = pkgs.openrgb-with-all-plugins; 
    motherboard = "amd"; 
    server = { 
      port = 6742; 
      autoStart = true; 
    }; 
  };
}
