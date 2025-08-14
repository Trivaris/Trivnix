{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.userPrefs;
in
{
  config = mkIf (builtins.elem "bitwarden" cfg.desktopApps) {
    home.packages = builtins.attrValues {
      inherit (pkgs) bitwarden-desktop;
    };
  };
}
