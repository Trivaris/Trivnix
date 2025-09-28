{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  config = mkIf (prefs.displayManager == "autologin") {
    assertions = import ./assertions.nix { inherit config prefs; };
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
