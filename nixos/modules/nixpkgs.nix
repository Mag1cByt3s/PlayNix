{ 
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}: {
  nixpkgs = {

     # Set host platform
     hostPlatform = lib.mkDefault "x86_64-linux";

     # You can add overlays here
     overlays = with inputs; [
       # Chaotic-Nyx overlay 
       (final: prev: {
         chaoticPkgs = import inputs.chaotic { inherit (prev) system; };
       })

       # NUR overlay
       inputs.nur.overlays.default
     ];

     # Configure your nixpkgs instance
     config = {
       # Disable if you don't want unfree packages
       allowUnfree = true;
     };
   };
}
