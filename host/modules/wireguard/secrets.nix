{
  lib,
  config,
  ...
}:
let 
  wireguardPrefs = config.hostPrefs.wireguard;
  hostSecrets = "${config.private.secrets}/host/${config.hostInfos.configname}.yaml";
in
{
  config.sops.secrets = {
    wireguard-server-key = lib.mkIf wireguardPrefs.server.enable {
      sopsFile = hostSecrets;
      owner = "root";
      group = "root";
    };

    wireguard-client-key = lib.mkIf wireguardPrefs.client.enable {
      sopsFile = hostSecrets;
      owner = "root";
      group = "root";
    };
  };
}