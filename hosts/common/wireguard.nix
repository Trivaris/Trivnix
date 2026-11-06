{ ... }:
{
  flake.nixosModules.common-wireguard =
    { lib, config, ... }:
    let
      localPeer = config.private.wgPeers.hosts.${config.hostInfos.configname};
      serverPeer = config.private.wgPeers.hosts.server;
    in
    {
      hostPrefs.wireguard = {
        enable = true;
        address = "10.0.0.${toString localPeer.id}/32";
        peers = [
          {
            publicKey = lib.removeSuffix "\n" (builtins.readFile serverPeer.key);
            allowedIPs = [ "10.0.0.0/24" ]; # Send all VPN traffic to the server
            endpoint = serverPeer.endpoint;
            persistentKeepalive = 25;
          }
        ];
      };
    };
}
