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
    programs.hyprland.enable = true;
    xdg.portal = {
      enable = true;
      config.common.default = "*";
    };
  };
}
