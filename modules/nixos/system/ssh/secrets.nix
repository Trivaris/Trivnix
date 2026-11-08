{
  flake.nixosModules.system-ssh =
    { config, ... }:
    {
      config.sops.secrets.ssh-root-key = {
        sopsFile = config.host.secrets.hostSecretsFile;
        path = "/root/.ssh/id_ed25519";
        owner = "root";
        group = "root";
      };
    };
}
