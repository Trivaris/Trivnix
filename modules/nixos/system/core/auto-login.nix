{
  flake.nixosModules.system-core =
    { config, ... }:
    {
      services.greetd =
        let
          session = {
            user = config.home.username;
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
    };
}
