{ config, ... }:
let
  prefs = config.hostPrefs;
in
{
  services.greetd =
    let
      session = {
        user = prefs.mainUser;
        command = "start-hyprland";
      };
    in
    {
      enable = true;
      settings = {
        default_session = session;
        initial_session = session;
      };
    };
}
