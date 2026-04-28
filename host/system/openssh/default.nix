{ config, lib, ... }:
let
  opensshPrefs = config.hostPrefs.openssh;
in
{
  config = lib.mkIf opensshPrefs.enable {
    networking.firewall.allowedTCPPorts = opensshPrefs.ports;
    services = {
      openssh = {
        inherit (opensshPrefs) ports;
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
}
