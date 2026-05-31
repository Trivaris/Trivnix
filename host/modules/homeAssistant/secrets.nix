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
  config.sops.secrets = {
    home-assistant-wireguard-key = lib.mkIf homeAssistantPrefs.wireguard.enable {
      sopsFile = hostSecrets;
      owner = "root";
      group = "root";
    };
  };
}
