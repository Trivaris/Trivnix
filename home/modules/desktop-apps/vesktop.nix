{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.userPrefs;
in
{
  config = mkIf (builtins.elem "vesktop" cfg.desktopApps) {
    programs.vesktop = {
      enable = true;
    };
  };
}
