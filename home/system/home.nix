{
  config,
  lib,
  pkgs,
  ...
}:
let 
  themingPrefs = config.themingPrefs;
in 
{
  home = {
    inherit (config.hostInfos) stateVersion;
    username = lib.mkDefault config.userInfos.name;
    homeDirectory = lib.mkDefault "/home/${config.userInfos.name}";

    sessionVariables = {
      TERMINAL = config.vars.terminalEmulator;
      NIX_LOG = "info";
      NIXOS_OZONE_WL = "1";
    };

    pointerCursor = {
      enable = true;
      name = themingPrefs.cursorName;
      package = themingPrefs.cursorPackage pkgs;
    };
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = lib.mkIf themingPrefs.darkmode "prefer-dark";

  gtk = lib.mkIf themingPrefs.darkmode {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
}
