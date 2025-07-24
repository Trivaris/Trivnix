{
  config,
  lib,
  pkgs,
  ...
}:
let
  greetdCmd = "env XDG_SESSION_TYPE=wayland dbus-run-session ${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland";
in
with lib;
{
  options.nixosConfig.kde.enable = mkEnableOption "KDE Desktop Manager";

  config = mkIf config.nixosConfig.kde.enable {
    services.desktopManager.plasma6.enable = true;

    nixosConfig.greetd.command = greetdCmd;
  };
}
