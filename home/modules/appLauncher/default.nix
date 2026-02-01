{ lib, ... }:
{
  options.vars = {
    appLauncher = lib.mkOption {
      type = lib.types.str;
      default = "rofi";
      readOnly = true;
    };

    appLauncherFlags = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = "-show drun";
    };
  };
}
