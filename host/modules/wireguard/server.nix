{
  lib,
  pkgs,
  config,
  ...
}:
let
  wgServerPrefs = config.hostPrefs.wireguard.server;
  secrets = config.sops.secrets;

  commonPeerKeys = lib.mapAttrsToList (name: value: {
    inherit value;
    name = lib.removeSuffix ".pub" name;
  }) config.private.pubKeys.common.wireguard;

  hostPeerKeys = lib.mapAttrsToList (name: value: {
    inherit name;
    value = value."wireguard.pub";
  }) config.private.pubKeys.hosts;

  peerPubkeys = commonPeerKeys ++ hostPeerKeys;

  peerRange = lib.range 0 ((builtins.length peerPubkeys) - 1);

  numberedPeers = builtins.listToAttrs (
    map (num: {
      name = toString (num + 2);
      value = builtins.elemAt peerPubkeys num;
    }) peerRange
  );

  peers = lib.mapAttrsToList (num: peerPubkey: {
    publicKey = builtins.readFile peerPubkey.value;
    # name = peerPubkey.name;
    allowedIPs = [ "10.100.0.${num}/32" ];
  }) numberedPeers;
in
{
  config = lib.mkIf wgServerPrefs.enable {
    networking.nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = wgServerPrefs.networkInterface;
      internalInterfaces = [ "wg0" ];
    };

    networking.firewall.allowedUDPPorts = [ wgServerPrefs.port ];

    networking.wg-quick.interfaces.wg0 = {
      inherit peers;
      address = [ "10.100.0.1/24" ];
      dns = [ "1.1.1.1" ];
      listenPort = wgServerPrefs.port;
      privateKeyFile = secrets.wireguard-server-key.path;
      postUp = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${wgServerPrefs.networkInterface} -j MASQUERADE
      '';
      preDown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${wgServerPrefs.networkInterface} -j MASQUERADE
      '';
    };
  };
}
