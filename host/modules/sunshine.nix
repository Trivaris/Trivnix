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
  options.hostPrefs.sunshine.enable = lib.mkEnableOption "Enable Sunshine game streaming server";

  config = lib.mkIf prefs.sunshine.enable {
    services.sunshine = {
      enable = true;
      package = pkgs.sunshine.override { 
        cudaSupport = true;
      };
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      applications.apps = [
        (lib.mkIf prefs.moondeck.enable {
          "name" = "MoonDeckStream";
          "auto-detach" = false;
          "cmd" = "${lib.getExe prefs.moondeck.package} --exec MoonDeckStream";
          "elevated" = false;
          "exclude-global-prep-cmd" = false;
          "exit-timeout" = 5;
          "wait-all" = false;
        })
      ];
    };
  };
}
