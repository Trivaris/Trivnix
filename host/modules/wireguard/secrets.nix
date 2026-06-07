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
  config.sops.secrets = lib.mkIf wireguardPrefs.enable {
    wireguard-key = {
      sopsFile = hostSecrets;
      owner = "root";
      group = "root";
    };
  };
}
