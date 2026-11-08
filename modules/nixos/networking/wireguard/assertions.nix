{
  flake.nixosModules.networking-wireguard =
    { config, lib, ... }:
    let
      wgPreferences = config.hosts.preferences.wireguard;
    in
    {
      config.assertions = [
        {
          assertion =
            wgPreferences.enable
            -> lib.any (peer: peer.publicKey != "" && peer.allowedIPs != [ ]) wgPreferences.peers;
          message = "host.preferences.wireguard.peers must contain at least one routed peer when WireGuard is enabled.";
        }
        {
          assertion =
            wgPreferences.enable -> lib.any (node: node.isServer -> node.endpoint != null) wgPreferences.nodes;
          message = "any server (peer.isServer = true) in host.preferences.wireguard.peers must have a publically reachable endpoint";
        }
        {
          assertion =
            wgPreferences.enable
            -> builtins.length (lib.filterAttrs (_: v: v.isServer) wgPreferences.nodes) == 1;
          message = "there must be exactly one wireguard server";
        }
        {
          assertion =
            wgPreferences.enable
            -> builtins.elem config.host.info.configName (builtins.attrNames wgPreferences.nodes);
          message = "local wireguard node must be defined";
        }
      ];
    };
}
