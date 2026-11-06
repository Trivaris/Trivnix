{
  imports = [
    ./options.nix
    ./secrets.nix
  ];

  flake.nixosModules.system-openssh =
    { config, lib, ... }:
    let
      openssh-prefs = config.host-prefs.openssh;
    in
    {
      config = lib.mkIf openssh-prefs.enable {
        networking.firewall.allowedTCPPorts = openssh-prefs.ports;
        services = {
          openssh = {
            inherit (openssh-prefs) ports;
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
