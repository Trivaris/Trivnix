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
  config = mkIf (builtins.elem "chromium" prefs.browsers) {
    home.packages = [ pkgs.chromium ];
  };
}
