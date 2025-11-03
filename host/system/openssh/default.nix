{ config, lib, ... }:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf prefs.openssh.enable {
    networking.firewall.allowedTCPPorts = prefs.openssh.ports;
    services = {
      openssh = {
        inherit (prefs.openssh) ports;
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
