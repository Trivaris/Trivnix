{
  flake.nixosModules.networking-wireguard =
    { config, lib, ... }:
    let
      wgPreferences = config.host.preferences.wireguard;
      nodes = builtins.attrValues wgPreferences.nodes;
      nodeNames = builtins.attrNames wgPreferences.nodes;
    in
    {
      config.assertions = [
        {
          assertion = wgPreferences.enable -> builtins.any (node: !node.isServer) nodes;
          message = "host.preferences.wireguard.nodes must contain at least one routed peer when WireGuard is enabled";
        }
        {
          assertion = wgPreferences.enable -> lib.any (node: node.isServer -> node.endpoint != null) nodes;
          message = "any server (peer.isServer = true) in host.preferences.wireguard.nodes must have a publically reachable endpoint";
        }
        {
          assertion =
            wgPreferences.enable -> builtins.length (builtins.filter (node: node.isServer) nodes) == 1;
          message = "there must be exactly one wireguard server";
        }
        {
          assertion = wgPreferences.enable -> builtins.elem config.host.info.configName nodeNames;
          message = "local wireguard node must be defined";
        }
      ];
    };
}
