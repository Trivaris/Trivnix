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

  options.nixosModules.openssh = {
    enable = mkEnableOption "OpenSSH Server";
    port = lib.mkOption {
      type = lib.types.int;
      default = 22;
      description = "OpenSSH server port";
    };
  };

  config = mkIf cfg.openssh.enable {
    services.openssh = {
      enable = true;
      ports = [ config.nixosModules.openssh.port ];

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
          path = config.sops.secrets.ssh-host-key.path;
          type = "ed25519";
        }
      ];
    };

    networking.firewall.allowedTCPPorts = [ config.nixosModules.openssh.port ];
  };

}
