{
  imports = [
    ./options.nix
  ];

  flake.nixosModules.services-glances =
    { config, lib, ... }:
    let
      glances-prefs = config.host-prefs.glances;
    in
    {
      config = lib.mkIf glances-prefs.enable {
        services.glances = {
          inherit (glances-prefs) port;
          enable = true;
          extraArgs = [
            "--webserver"
            "--disable-webui"
          ];
        };
      };
    };
}
