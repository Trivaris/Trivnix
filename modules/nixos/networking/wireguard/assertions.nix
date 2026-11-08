{
  flake.nixosModules.networking-wireguard =
    { config, lib, ... }:
    {
      config.assertions = [
        {
          assertion =
            !config.host.preferences.wireguard.enable
            || lib.any (
              peer: peer.publicKey != "" && peer.allowedIPs != [ ]
            ) config.host.preferences.wireguard.peers;
          message = "host.preferences.wireguard.peers must contain at least one routed peer when WireGuard is enabled.";
        }
      ];
    };
}
