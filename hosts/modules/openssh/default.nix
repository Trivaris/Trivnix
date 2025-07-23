{
  config,
  lib,
  hostconfig,
  ...
}:
let
  cfg = config.nixosConfig;
in
with lib;
{
  options.nixosConfig.openssh = import ./config.nix lib;

  config = mkIf (cfg.openssh.enable) {
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
