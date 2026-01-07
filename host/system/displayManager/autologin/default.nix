{ config, lib, ... }:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf (prefs.displayManager == "autologin") {
    services.greetd =
      let
        settings = {
          default_session = settings.initial_session;
          initial_session = {
            user = prefs.mainUser;
            command = config.home-manager.users.${prefs.mainUser}.vars.desktopEnvironmentBinary;
          };
        };
      in
      {
        inherit settings;
        enable = true;
      };
  };
}
