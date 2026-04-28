{ config, ... }:
{
  services.greetd =
    let
      session = {
        user = config.hostPrefs.mainUser;
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
