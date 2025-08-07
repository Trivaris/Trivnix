{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.homeConfig;
in
{
  config = mkIf (builtins.elem "chatgpt" cfg.desktopApps) {
    home.packages = builtins.attrValues {
      inherit (pkgs) chatgpt;
    };
  };
}
