{ config, lib, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{
  options.homeConfig.vesktop.enable = mkEnableOption "Enable the discord client Vesktop";

  config = mkIf cfg.vesktop.enable {
    programs.vesktop = {
      enable = true;
    };
  };
}
