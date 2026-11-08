{
  flake.nixosModules.networking-wireguard =
    {
      lib,
      config,
      ...
    }:
    let
      wgPreferences = config.host.preferences.wireguard;
      secrets = config.sops.secrets;
      myNode = wgPreferences.nodes.${config.host.info.configName};
      peers = lib.filterAttrs (_: node: !node.isServer) wgPreferences.nodes;
      server = lib.filterAttrs (_: node: node.isServer) wgPreferences.nodes;

      readKey = file: lib.removeSuffix "\n" (builtins.readFile file);
      pow2 = n: if n == 0 then 1 else 2 * (pow2 (n - 1));

      getHostId =
        ipId:
        let
          hostBits = 32 - wgPreferences.subnetMask;
          hostSpace = pow2 hostBits;
        in
        lib.mod ipId hostSpace;

      ipToInt =
        ipStr:
        let
          octets = map lib.toInt (lib.splitString "." ipStr);
          o0 = builtins.elemAt octets 0;
          o1 = builtins.elemAt octets 1;
          o2 = builtins.elemAt octets 2;
          o3 = builtins.elemAt octets 3;
        in
        lib.throwIfNot (
          builtins.length octets == 4
        ) "${ipStr} is not a valid ip string, must be of form '0.0.0.0'" (o0 * 16777216)
        + (o1 * 65536)
        + (o2 * 256)
        + o3;

      # Convert the subnet string to a 32-bit integer
      subnetInt = ipToInt wgPreferences.subnet;

      # The base network integer (e.g., 168427520 for 10.0.0.0)
      subnetId = subnetInt - (getHostId subnetInt);

      # Converts a 32-bit integer to exactly 4 padded octets
      idToOctets =
        id:
        let
          recur = n: if n < 256 then [ n ] else (recur (builtins.div n 256)) ++ [ (lib.mod n 256) ];
          rawOctets = recur id;
          padding = 4 - builtins.length rawOctets;
        in
        if padding > 0 then (lib.genList (_: 0) padding) ++ rawOctets else rawOctets;

      getNodeAddress =
        node:
        lib.pipe node.id [
          getHostId
          (n: subnetId + n)
          idToOctets
          (map toString)
          (lib.concatStringsSep ".")
        ];

      mapNodeToPeer = _: node: {
        publicKey = readKey node.publicKeyFile;
        allowedIPs = [
          "${getNodeAddress node}/${if node.isServer then toString wgPreferences.subnetMask else "32"}"
        ];
        endpoint = node.endpoint;
        persistentKeepalive = 25;
      };
    in
    {
      config = lib.mkIf wgPreferences.enable {
        networking.firewall = {
          allowedUDPPorts = [ wgPreferences.port ];
          trustedInterfaces = [ wgPreferences.interfaceName ];
        };

        networking.wireguard.interfaces."${wgPreferences.interfaceName}" = {
          ips = [ "${getNodeAddress myNode}/${toString wgPreferences.subnetMask}" ];
          listenPort = wgPreferences.port;
          privateKeyFile = secrets.wireguard-key.path;
          peers = lib.mapAttrsToList mapNodeToPeer (if myNode.isServer then peers else server);
        };
      };
    };
}
