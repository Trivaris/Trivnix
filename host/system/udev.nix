{
  config,
  lib,
  pkgs,
  ...
}:
let
  udevPrefs = config.hostPrefs.udev;
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

  config = lib.mkIf udevPrefs.enable {
    services.udev = {
      enable = true;
      extraRules = udevPrefs.rules pkgs;
    };
  };
}
