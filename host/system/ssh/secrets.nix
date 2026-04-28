{ config, ... }:
let 
  hostSecrets = "${config.private.secrets}/host/${config.hostInfos.configname}.yaml";
in 
{
  config.sops.secrets.ssh-root-key = {
    sopsFile = hostSecrets;
    path = "/root/.ssh/id_ed25519";
    owner = "root";
    group = "root";
  };
}