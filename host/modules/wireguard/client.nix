{
  lib,
  config,
  ...
}:
let
  wgClientPrefs = config.hostPrefs.wireguard.client;
  secrets = config.sops.secrets;
in
{
  config = lib.mkIf wgClientPrefs.enable {
    systemd.services.wg-quick-wg0.wantedBy = lib.mkForce [ ];
    networking.firewall.allowedUDPPorts = [ wgClientPrefs.port ];
    networking.wg-quick.interfaces.wg0 = {
      address = [ "${wgClientPrefs.ip}/24" ];
      dns = [ "1.1.1.1" ];
      privateKeyFile = secrets.wireguard-client-key.path;

      peers = [
        {
          publicKey =
            builtins.readFile
              config.private.pubKeys.hosts.${wgClientPrefs.serverConfigname}."wireguard.pub";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "${wgClientPrefs.serverAddress}:${toString wgClientPrefs.port}";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
