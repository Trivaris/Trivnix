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
  config = lib.mkIf wireguardPrefs.client.enable {
    systemd.services.wg-quick-wg0.wantedBy = lib.mkForce [ ];
    networking.firewall.allowedUDPPorts = [ wireguardPrefs.client.port ];
    networking.wg-quick.interfaces.wg0 = {
      address = [ "${wireguardPrefs.client.ip}/24" ];
      dns = [ "1.1.1.1" ];
      privateKeyFile = secrets.wireguard-client-key.path;

      peers = [
        {
          publicKey =
            builtins.readFile
              config.private.pubKeys.hosts.${wireguardPrefs.client.serverConfigname}."wireguard.pub";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "${wireguardPrefs.client.serverAddress}:${toString wireguardPrefs.client.port}";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
