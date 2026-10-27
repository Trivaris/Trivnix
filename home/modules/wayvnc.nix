{
  config,
  lib,
  ...
}:
let
  wayvncPrefs = config.userPrefs.wayvnc;
in
{
  options.userPrefs.wayvnc.enable = lib.mkEnableOption "Remote desktop access via WayVNC";

  config = lib.mkIf wayvncPrefs.enable {
    services.wayvnc = {
      enable = true;
      autoStart = true;
      settings = {
        address = "0.0.0.0";
        port = 5900;
      };
    };
  };
}
