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
  config = mkIf (builtins.elem "signal" prefs.gui) {
    home.packages = builtins.attrValues {
      inherit (pkgs) signal-desktop;
    };
  };
}
