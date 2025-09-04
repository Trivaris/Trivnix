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
  config = mkIf (builtins.elem "chatgpt" prefs.desktopApps) {
    home.packages = builtins.attrValues {
      inherit (pkgs) chatgpt;
    };
  };
}
