{
  flake.nixosModules.services-syncthing =
    {
      lib,
      config,
      ...
    }:
    let
      syncthing-prefs = config.host-prefs.syncthing;
      host-secrets = "${config.private.secrets}/host/${config.host-infos.configname}.yaml";
    in
    {
      config.sops.secrets = lib.mkIf syncthing-prefs.enable {
        syncthing-gui-password = {
          sopsFile = host-secrets;
          owner = "syncthing";
          group = "syncthing";
        };
      };
    };
}
