{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hostPrefs;
in
{
  options.hostPrefs.printing.enable = mkEnableOption "Printing";

  config = mkIf (cfg.printing.enable) {
    services.printing = {
      enable = true;
      drivers = [ pkgs.samsung-unified-linux-driver ];
    };
    systemd.services.cups-browsed = {
      enable = false;
      unitConfig.Mask = true;
    };
  };
}
