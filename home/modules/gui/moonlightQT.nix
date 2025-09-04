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
  config = mkIf (builtins.elem "moonlightQT" prefs.gui) {
    home.packages = [ pkgs.moonlight-qt ];
  };
}
