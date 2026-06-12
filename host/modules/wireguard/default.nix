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
    networking.firewall.allowedUDPPorts = lib.mkIf wireguardPrefs.enable [ wireguardPrefs.port ];

    networking.wireguard.interfaces."${wireguardPrefs.interfaceName}" = lib.mkIf wireguardPrefs.enable {
      ips = [ wireguardPrefs.vpnSubnet ];
      listenPort = wireguardPrefs.port;
      privateKeyFile = secrets.wireguard-key.path;
      peers = wireguardPrefs.peers;
    };
  };
}
