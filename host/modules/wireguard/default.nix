{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.wireguard = import ./options.nix { inherit (lib) mkEnableOption mkOption types; };
  config = mkIf prefs.wireguard.enable {
    boot.kernel.sysctl."net.ipv4.ip_forward" = true;
    networking = {
      firewall.checkReversePath = "loose";
      wireguard = {
        enable = true;
        interfaces.wg0 = {
          privateKeyFile = config.sops.secrets.wg-server-key.path;
          listenPort = prefs.wireguard.port;
          ips = [ "10.0.0.1/24" ];
          peers = [
            {
              # FritzBox
              inherit (prefs.wireguard) publicKey;
              allowedIPs = [ "10.0.0.2/32" ];
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
  };
}
