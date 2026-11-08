{
  flake.nixosModules.system-openssh =
    { config, lib, ... }:
    let
      opensshPreferences = config.host.preferences.openssh;
    in
    {
      config = lib.mkIf opensshPreferences.enable {
        networking.firewall.allowedTCPPorts = opensshPreferences.ports;
        services = {
          openssh = {
            inherit (opensshPreferences) ports;
            enable = true;
            openFirewall = true;

            settings = {
              PasswordAuthentication = false;
              PermitRootLogin = "no";
              StreamLocalBindUnlink = "yes";
              GatewayPorts = "clientspecified";
            };

            hostKeys = [
              {
                inherit (config.sops.secrets.ssh-host-key) path;
                type = "ed25519";
              }
            ];
          };

          fail2ban = {
            enable = true;
            jails.sshd.settings = {
              port = "ssh";
              filter = "sshd";
              logpath = "/var/log/auth.log";
              maxretry = 3;
            };
          };
        };
      };
    };
}
