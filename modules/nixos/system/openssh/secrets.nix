{
  flake.nixosModules.system-openssh =
    {
      lib,
      config,
      ...
    }:
    let
      openssh-prefs = config.host-prefs.openssh;
      host-secrets = "${config.private.secrets}/host/${config.host-infos.configname}.yaml";
    in
    {
      config.sops.secrets = lib.mkIf openssh-prefs.enable {
        ssh-host-key = {
          sopsFile = host-secrets;
          path = "/etc/ssh/ssh_host_ed25519_key";
          owner = "root";
          group = "root";
          restartUnits = [ "sshd.service" ];
          neededForUsers = true;
        };
      };
    };
}
