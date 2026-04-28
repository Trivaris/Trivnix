{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf (!config.hostPrefs.headless) {
    environment.systemPackages = [ pkgs.sbctl ];
    security.pam.services.hyprlock = { };
    
    programs.hyprland = {
      enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      package = pkgs.hyprland;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      config.common.default = "*";
    };
  };
}
