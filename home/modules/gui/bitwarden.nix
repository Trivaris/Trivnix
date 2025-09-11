{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (builtins.elem "bitwarden" prefs.gui) {
    home.packages = [ pkgs.bitwarden-desktop ];
  };
}
