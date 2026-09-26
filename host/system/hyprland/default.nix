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

    # services.keyd = {
    #   enable = true;
    #   keyboards.default = {
    #     ids = [ "*" ];
    #     settings.main.space = "overload(meta, space)"; 
    #   };
    # };

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
