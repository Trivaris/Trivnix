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
    networking.firewall.allowedUDPPorts = [ prefs.wireguard.client.port ];
    networking.wireguard.interfaces = {
      wg0 = {
        ips = [ "${prefs.wireguard.client.ip}/24" ];
        listenPort = prefs.wireguard.client.port;
        privateKeyFile = config.sops.secrets.wireguard-client-key.path;

        peers = [
          {
            publicKey =
              builtins.readFile
                config.private.pubKeys.hosts.${prefs.wireguard.client.serverConfigname}."wireguard.pub";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "${prefs.wireguard.client.serverAddress}:${prefs.wireguard.client.port}";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
