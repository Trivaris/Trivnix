{
  flake.homeModules.system-ssh =
    {
      config,
      osConfig,
      ...
    }:
    let
      host-secrets = "${osConfig.private.secrets}/home/${config.home.username}/${osConfig.host-infos.configname}.yaml";
    in
    {
      config.sops.secrets.ssh-private-key = {
        sopsFile = host-secrets;
      };
    };
}
