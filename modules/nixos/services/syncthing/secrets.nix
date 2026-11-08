{
  flake.nixosModules.services-syncthing =
    {
      lib,
      config,
      ...
    }:
    let
      syncthingPreferences = config.host.preferences.syncthing;
    in
    {
      config.sops.secrets = lib.mkIf syncthingPreferences.enable {
        syncthing-gui-password = {
          sopsFile = config.host.secrets.hostSecretsFile;
          owner = "syncthing";
          group = "syncthing";
        };
      };
    };
}
