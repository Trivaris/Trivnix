{
  lib,
  config,
  ...
}:
let
  syncthingPrefs = config.hostPrefs.syncthing;
  hostSecrets = "${config.private.secrets}/host/${config.hostInfos.configname}.yaml";
in 
{
  config.sops.secrets = lib.mkIf syncthingPrefs.enable {
    syncthing-gui-password = {
      owner = "syncthing";
      group = "syncthing";
      sopsFile = hostSecrets;
    };
  };
}