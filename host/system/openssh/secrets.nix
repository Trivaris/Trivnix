{
  lib,
  config,
  ...
}:
let 
  opensshPrefs = config.hostPrefs.openssh;
  hostSecrets = "${config.private.secrets}/host/${config.hostInfos.configname}.yaml";
in
{
  config.sops.secrets = lib.mkIf opensshPrefs.enable {
    ssh-host-key = {
      sopsFile = hostSecrets;
      path = "/etc/ssh/ssh_host_ed25519_key";
      owner = "root";
      group = "root";
      restartUnits = [ "sshd.service" ];
      neededForUsers = true;
    };
  };
}