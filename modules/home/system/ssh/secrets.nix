{
  flake.homeModules.system-ssh =
    {
      config,
      osConfig,
      ...
    }:
    let
      hostSecrets = "${osConfig.private.secrets}/home/${config.userInfos.name}/${osConfig.hostInfos.configname}.yaml";
    in
    {
      config.sops.secrets.ssh-private-key = {
        sopsFile = hostSecrets;
      };
    };
}
