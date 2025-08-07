{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nixosConfig;
in
{
  options.nixosConfig.gdm.enable = mkEnableOption "Enable Gnome Display Manager";

  config = mkIf cfg.gdm.enable {
    services.displayManager.gdm = {
      enable = true;
    };
  };
}
