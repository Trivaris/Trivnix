{ config, lib, ... }:
let
  cfg = config.nixosConfig;
in
with lib;
{
  options.nixosConfig.gdm.enable = mkEnableOption "Enable Gnome Display Manager";

  config = mkIf cfg.gdm.enable {
    services.displayManager.gdm = {
      enable = true;
    };
  };
}
