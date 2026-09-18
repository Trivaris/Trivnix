{ config, ... }:
{
  services.greetd =
    let
      session = {
        user = config.hostPrefs.mainUser;
        command = "sh -c 'start-hyprland > /dev/null 2>&1'";
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
