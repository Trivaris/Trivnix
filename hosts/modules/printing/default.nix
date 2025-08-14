{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hostprefs;
in
{
  options.hostprefs.printing.enable = mkEnableOption "Printing";

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
