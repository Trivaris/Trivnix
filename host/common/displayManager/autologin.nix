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
      description = "The User you want to automatically log in if autologin is set as the display manager";
    };
  };

  config = mkIf (prefs.displayManager == "autologin") {
    assertions = [
      {
        assertion = config.vars.desktopEnvironmentBinary != null;
        message = ''Autologin requires a desktop environment. Set hostPrefs.desktopEnvironment to a module that sets vars.desktopEnvironmentBinary.'';
      }
      {
        assertion = prefs.autologin.user != "";
        message = ''Autologin user is empty. Set hostPrefs.autologin.user to a valid username.'';
      }
    ];

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
