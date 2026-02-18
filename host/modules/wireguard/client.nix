{
  lib,
  config,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf prefs.wireguard.client.enable {
    systemd.services.wg-quick-wg0.wantedBy = lib.mkForce [ ];
    networking.firewall.allowedUDPPorts = [ prefs.wireguard.client.port ];
    networking.wg-quick.interfaces.wg0 = {
      address = [ "${prefs.wireguard.client.ip}/24" ];
      dns = [ "1.1.1.1" ];
      privateKeyFile = config.sops.secrets.wireguard-client-key.path;

      peers = [
        {
          publicKey =
            builtins.readFile
              config.private.pubKeys.hosts.${prefs.wireguard.client.serverConfigname}."wireguard.pub";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "${prefs.wireguard.client.serverAddress}:${toString prefs.wireguard.client.port}";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
