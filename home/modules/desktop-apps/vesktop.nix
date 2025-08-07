{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.homeConfig;
in
{
  config = mkIf (builtins.elem "vesktop" cfg.desktopApps) {
    programs.vesktop = {
      enable = true;
    };
  };
}
