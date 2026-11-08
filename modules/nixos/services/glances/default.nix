{
  flake.nixosModules.services-glances =
    { config, lib, ... }:
    let
      glancesPreferences = config.host.preferences.glances;
    in
    {
      config = lib.mkIf glancesPreferences.enable {
        services.glances = {
          inherit (glancesPreferences) port;
          enable = true;
          extraArgs = [
            "--webserver"
            "--disable-webui"
          ];
        };
      };
    };
}
