{
  config,
  lib,
  usernames,
  ...
}:
let
  cfg = config.nixosModules;
in
with lib;
{

  options.sshPort = lib.mkOption {
    type = lib.types.int;
    default = 22;
    description = "OpenSSH server port";
  };

  options.nixosModules.openssh = mkEnableOption "OpenSSH Server";

  config = mkIf cfg.openssh {
    services.openssh = {
      enable = true;
      ports = [ config.sshPort ];

      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        StreamLocalBindUnlink = "yes";
        GatewayPorts = "clientspecified";
      };

      authorizedKeysFiles = builtins.map (user: "/etc/ssh/authorized_keys.d/${user}") usernames;

      openFirewall = true;

      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };

    networking.firewall.allowedTCPPorts = [ config.sshPort ];
  };

}
