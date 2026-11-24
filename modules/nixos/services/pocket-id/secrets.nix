{
  flake.nixosModules.services-pocket-id = { config, ... }: {
    sops.secrets.pocket-id-encryption-key = {
      sopsFile = config.host.private.secrets.hostSecretsFile;
      owner = config.services.pocket-id.user;
      group = config.services.pocket-id.group;
      mode = "0400";
    };
  };
}