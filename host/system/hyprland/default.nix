{
  lib,
  config,
  pkgs,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf (!prefs.headless) {
    security.pam.services.hyprlock = { };
    programs.hyprland = {
      enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      package = pkgs.hyprland;
    };
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };
  };
}
