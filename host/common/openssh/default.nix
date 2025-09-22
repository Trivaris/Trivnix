{
  config,
  lib,
  allUserInfos,
  ...
}:
let
  inherit (lib) mkIf pipe;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.openssh = import ./options.nix { inherit (lib) mkEnableOption mkOption types; };

  config = mkIf prefs.openssh.enable {
    services.openssh = {
      inherit (prefs.openssh) ports;
      enable = true;
      openFirewall = true;

      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        StreamLocalBindUnlink = "yes";
        GatewayPorts = "clientspecified";
      };

      authorizedKeysFiles = pipe allUserInfos [
        builtins.attrNames
        (map (user: "/etc/ssh/authorized_keys.d/${user}"))
      ];

      hostKeys = [
        {
          inherit (config.sops.secrets.ssh-host-key) path;
          type = "ed25519";
        }
      ];
    };

    networking.firewall.allowedTCPPorts = prefs.openssh.ports;
  };
}
