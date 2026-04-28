{
  lib,
  config,
  pkgs,
  ...
}:
let
  sunshinePrefs = config.hostPrefs.sunshine;
  moondeckPrefs = config.hostPrefs.moondeck;
in
{
  options.hostPrefs.sunshine.enable = lib.mkEnableOption "Enable Sunshine game streaming server";

  config = lib.mkIf sunshinePrefs.enable {
    services.sunshine = {
      enable = true;
      package = pkgs.sunshine.override {
        cudaSupport = true;
      };
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      applications.apps = [
        (lib.mkIf moondeckPrefs.enable {
          "name" = "MoonDeckStream";
          "auto-detach" = false;
          "cmd" = "${lib.getExe moondeckPrefs.package} --exec MoonDeckStream";
          "elevated" = false;
          "exclude-global-prep-cmd" = false;
          "exit-timeout" = 5;
          "wait-all" = false;
        })
      ];
    };
  };
}
