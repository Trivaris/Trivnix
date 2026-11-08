{
  flake.nixosModules.system-openssh =
    {
      lib,
      config,
      ...
    }:
    let
      opensshPreferences = config.host.preferences.openssh;
    in
    {
      config.sops.secrets = lib.mkIf opensshPreferences.enable {
        ssh-host-key = {
          sopsFile = config.host.private.secrets.hostSecretsFile;
          path = "/etc/ssh/ssh_host_ed25519_key";
          owner = "root";
          group = "root";
          restartUnits = [ "sshd.service" ];
          neededForUsers = true;
        };
      };
    };
}
