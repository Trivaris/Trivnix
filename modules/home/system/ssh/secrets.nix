{
  flake.homeModules.system-ssh =
    { config, ... }:
    {
      config.sops.secrets.ssh-private-key = {
        sopsFile = config.user.private.secrets.userSecretsFile;
      };
    };
}
