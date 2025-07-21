
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixosConfig;
in
with lib;
{

  options.nixosConfig.kde.enable = mkEnableOption "KDE Desktop Manager";

  config = mkIf cfg.kde.enable {
    services.desktopManager.plasma6.enable = true;
    nixosConfig.tuigreet.command = "env XDG_SESSION_TYPE=wayland dbus-run-session ${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland";
  };
}