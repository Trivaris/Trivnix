{
  config,
  osConfig,
  ...
}:
let
  hostSecrets = "${config.private.secrets}/home/${config.userInfos.name}/${osConfig.hostInfos.configname}.yaml";
in
{
  config.sops.secrets.ssh-private-key = {
    sopsFile = hostSecrets;
    owner = config.userInfos.name;
    group = "users";
  };
}
