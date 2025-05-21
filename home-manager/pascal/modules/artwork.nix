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

  home.file.".local/share/icons/playnix/" = {
    source    = "${flakeSrc}/assets/icons";
    recursive = true;
    force     = true;
  };
}
