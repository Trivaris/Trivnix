{ config, lib, pkgs, ... }:
with lib;
{
  options.nixosConfig.kde.enable = mkEnableOption "Enable KDE Plasma";

  config = mkIf config.nixosConfig.kde.enable {
    services.desktopManager.plasma6.enable = true;

    nixosConfig.greetd.command = ''
      env XDG_SESSION_TYPE=wayland dbus-run-session ${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland
    '';

  };
}
