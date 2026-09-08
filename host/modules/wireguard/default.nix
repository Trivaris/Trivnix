{
  lib,
  config,
  ...
}:
let
  wireguardPrefs = config.hostPrefs.wireguard;
  secrets = config.sops.secrets;
in
{
  config = lib.mkIf wireguardPrefs.enable {
    networking.firewall = {
      allowedUDPPorts = [ wireguardPrefs.port ];
      trustedInterfaces = [ "wg0" ];
    };

    networking.wireguard.interfaces."${wireguardPrefs.interfaceName}" = {
      ips = [ wireguardPrefs.address ];
      listenPort = wireguardPrefs.port;
      privateKeyFile = secrets.wireguard-key.path;
      peers = wireguardPrefs.peers;
    };
  };
}
