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
  config = mkIf (builtins.elem "moonlight-qt" prefs.desktopApps) {
    home.packages = builtins.attrValues {
      inherit (pkgs) moonlight-qt;
    };
  };
}
