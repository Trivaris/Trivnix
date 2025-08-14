{
  config,
  lib,
  allUserInfos,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.hostPrefs;
in
{
  options.hostPrefs.openssh = import ./config.nix { inherit (lib) mkEnableOption mkOption types; };

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

      authorizedKeysFiles = builtins.map (user: "/etc/ssh/authorized_keys.d/${user}") (builtins.attrNames allUserInfos);

      openFirewall = true;

      hostKeys = [
        {
          path = config.sops.secrets.ssh-host-key.path;
          type = "ed25519";
        }
      ];
    };

    networking.firewall.allowedTCPPorts = cfg.openssh.ports;
  };
}
