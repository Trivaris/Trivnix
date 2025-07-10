{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules;
in
with lib;
{

  options.nixosModules.sunshine = mkEnableOption "Sunshine";

  config = mkIf cfg.sunshine {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };

}
