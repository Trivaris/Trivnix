{ config, lib, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{
  config = mkIf (builtins.elem "vesktop" cfg.desktopApps) {
    programs.vesktop = {
      enable = true;
    };
  };
}
