{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.autoLoginUser = mkOption {
    type = types.str;
    default = "";
    description = "Ther User yout want to automatically log in if autologin is set as the displayManager";
  };

  config = mkIf (prefs.displayManager == "autoLogin") {
    services.displayManager.autoLogin = {
      enable = true;
      user = prefs.autoLoginUser;
    };
  };
}