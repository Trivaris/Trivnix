{
  flake.nixosModules.system-ssh =
    { config, ... }:
    let
      host-secrets = "${config.private.secrets}/host/${config.host-infos.configname}.yaml";
    in
    {
      config.sops.secrets.ssh-root-key = {
        sopsFile = host-secrets;
        path = "/root/.ssh/id_ed25519";
        owner = "root";
        group = "root";
      };
    };
}
