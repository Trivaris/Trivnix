{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.userPrefs;
in
{
  config = mkIf (builtins.elem "moonlight-qt" cfg.desktopApps) {
    home.packages = builtins.attrValues {
      inherit (pkgs) moonlight-qt;
    };
  };
}
