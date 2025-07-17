{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixosModules;
in
with lib;
{

  options.nixosModules.printing.enable = mkEnableOption "Printing";

  config = mkIf cfg.printing.enable {
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
