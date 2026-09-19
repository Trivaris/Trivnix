{ osConfig, config, pkgs, lib, ... }:
{
  config = lib.mkIf (!osConfig.hostPrefs.headless) {
    systemd.user.services.quickshell.Service.Environment = "QSG_RHI_BACKEND=vulkan QML_XHR_ALLOW_FILE_READ=1";
    programs.quickshell = {
      enable = true;
      systemd.enable = true;
    };
    home = {
      packages = [ pkgs.quickshell ];
      file = {
        ".config/quickshell/wsIconOverrides.json".text = builtins.toJSON config.userPrefs.quickshell.wsIconOverrides;
        ".config/quickshell/scheme.json".text = builtins.toJSON osConfig.themingPrefs.scheme;
        ".config/quickshell/monitors.json".text = builtins.toJSON osConfig.hostInfos.monitors;
        ".config/quickshell/weather.sh" = {
          executable = true;
          text = import ./_scripts/weather.nix pkgs;
        };
        ".config/quickshell" = {
          recursive = true;
          source = ./_modules;
        };
      };
    };
  };
}