{
  config,
  lib,
  pkgs,
  ...
}:
let
  prefs = config.hostPrefs.udev;
in
{
  options.hostPrefs.udev = {
    enable = lib.mkEnableOption "Enable Custom udev rules";
    rules = lib.mkOption {
      type = lib.types.functionTo lib.types.str;
      default = "";
      description = "Custom udev rules to be added to the system.";
    };
  };

  config = lib.mkIf prefs.enable {
    services.udev = {
      enable = true;
      extraRules = prefs.rules pkgs;
    };
  };
}
