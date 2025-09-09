{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.autologin = {
    loginOnce = mkEnableOption "Only log in automatically once";

    user = mkOption {
      type = types.str;
      default = "";
      description = "Ther User you want to automatically log in if autologin is set as the display manager";
    };
  };

  config = mkIf (prefs.displayManager == "autologin") {
    services = {
      getty = {
        autologinUser = prefs.autologin.user;
        autologinOnce = prefs.autologin.loginOnce;
      };
    };
  };
}
