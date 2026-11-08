{
  flake.homeModules.system-ssh =
    {
      config,
      osConfig,
      ...
    }:
    let
      hostSecrets = "${osConfig.private.secrets}/home/${config.home.username}/${osConfig.host.info.configName}.yaml";
    in
    {
      config.sops.secrets.ssh-private-key = {
        sopsFile = hostSecrets;
      };
    };
}
