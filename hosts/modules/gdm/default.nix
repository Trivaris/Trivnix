{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hostPrefs;
in
{
  options.hostPrefs.gdm.enable = mkEnableOption "Enable Gnome Display Manager";

  config = mkIf cfg.gdm.enable {
    services.displayManager.gdm = {
      enable = true;
    };
  };
}
