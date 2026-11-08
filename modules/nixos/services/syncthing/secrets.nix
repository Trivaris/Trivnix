{
  flake.nixosModules.services-syncthing =
    {
      lib,
      config,
      ...
    }:
    let
      syncthingPreferences = config.host.preferences.syncthing;
      hostSecrets = "${config.private.secrets}/host/${config.host.info.configName}.yaml";
    in
    {
      config.sops.secrets = lib.mkIf syncthingPreferences.enable {
        syncthing-gui-password = {
          sopsFile = hostSecrets;
          owner = "syncthing";
          group = "syncthing";
        };
      };
    };
}
