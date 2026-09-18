{ osConfig, lib, ... }:
{
  config = lib.mkIf (!osConfig.hostPrefs.headless) {
    programs.quickshell = {
      enable = true;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
    };
    home.file = {
      ".config/quickshell/theme.json".text = builtins.toJSON osConfig.themingPrefs.scheme;
      ".config/quickshell" = {
        recursive = true;
        source = ./_qsmodules;
      };
    };
  };
}