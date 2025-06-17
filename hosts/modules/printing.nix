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

  options.nixosModules.printing = mkEnableOption "Printing";

  config = mkIf cfg.printing {
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
