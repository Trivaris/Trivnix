{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (builtins.elem "bitwarden" prefs.desktopApps) {
    home.packages = [ pkgs.bitwarden-desktop ];
  };
}
