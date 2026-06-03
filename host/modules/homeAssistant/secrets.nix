{
  lib,
  config,
  ...
}:
let
  homeAssistantPrefs = config.hostPrefs.homeAssistant;
  hostSecrets = "${config.private.secrets}/host/${config.hostInfos.configname}.yaml";
in
{
  config.sops.secrets = lib.mkIf homeAssistantPrefs.wireguard.enable {
    home-assistant-wireguard-key = {
      sopsFile = hostSecrets;
      owner = "root";
      group = "root";
    };
  };
}
