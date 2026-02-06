{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let 
  themingPrefs = osConfig.themingPrefs;
in 
{
  home = {
    inherit (osConfig.hostInfos) stateVersion;
    username = lib.mkDefault config.userInfos.name;
    homeDirectory = lib.mkDefault "/home/${config.userInfos.name}";
    uid = config.userInfos.uid;

    shell.enableZshIntegration = true;

    sessionVariables = {
      TERMINAL = config.vars.terminalEmulator;
      NIX_LOG = "info";
      NIXOS_OZONE_WL = "1";
    };

    pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      hyprcursor.enable = true;
      size = 24;
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
    };

    packages = [
      pkgs.gsettings-desktop-schemas
      pkgs.adwaita-icon-theme
      pkgs.gnome-themes-extra
    ];
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = if themingPrefs.darkmode then "prefer-dark" else "prefer-light";

  gtk = {
    enable = true;
    colorScheme = if themingPrefs.darkmode then "dark" else "light";
    theme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    font = {
      name = themingPrefs.font.name;
      package = themingPrefs.font.package;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
}
