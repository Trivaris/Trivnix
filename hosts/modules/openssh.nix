{
  config,
  lib,
  hostconfig,
  ...
}:
let
  cfg = config.nixosModules;
in
with lib;
{

  options.nixosModules.openssh = {
    enable = mkEnableOption "OpenSSH Server";

    ports = mkOption {
      type = types.listOf types.int;
      default = [ 22 ];
      description = ''
        TCP port the OpenSSH daemon will listen on.
        Ensure this port is allowed through the firewall if accessing remotely.
      '';
    };
  };

  config = mkIf cfg.openssh.enable {
    services.openssh = {
      enable = true;
      ports = cfg.openssh.ports;

      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        StreamLocalBindUnlink = "yes";
        GatewayPorts = "clientspecified";
      };

      authorizedKeysFiles = builtins.map (user: "/etc/ssh/authorized_keys.d/${user}") hostconfig.users;

      openFirewall = true;

      hostKeys = [{
        path = config.sops.secrets.ssh-host-key.path;
        type = "ed25519";
      }];
    };

    networking.firewall.allowedTCPPorts = cfg.openssh.ports;
  };

}
