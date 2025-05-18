{
  config,
  pkgs,
  lib,
  flakeSrc,
  ...
}: {
  home.file.".local/share/wallpapers/playnix/" = {
    source    = "${flakeSrc}/assets/wallpapers";
    recursive = true;
    force     = true;
  };
}
