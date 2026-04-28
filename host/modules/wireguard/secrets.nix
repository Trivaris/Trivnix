{
  lib,
  config,
  ...
}:
let 
  wgServerPrefs = config.hostPrefs.wireguard.server;
  wgClientPrefs = config.hostPrefs.wireguard.client;
  hostSecrets = "${config.private.secrets}/host/${config.hostInfos.configname}.yaml";
in
{
  config.sops.secrets = {
    wireguard-server-key = lib.mkIf wgServerPrefs.enable {
      sopsFile = hostSecrets;
      owner = "root";
      group = "root";
    };

    wireguard-client-key = lib.mkIf wgClientPrefs.enable {
      sopsFile = hostSecrets;
      owner = "root";
      group = "root";
    };
  };
}