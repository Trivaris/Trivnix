{
  config,
  lib,
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
    services.greetd =
      let
        settings = {
          default_session = settings.initial_session;
          initial_session = {
            inherit (prefs.autologin) user;
            command = config.vars.desktopEnvironmentBinary;
          };
        };
      in
      {
        enable = true;
        inherit settings;
      };
  };
}
