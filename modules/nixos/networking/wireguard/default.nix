{
  flake.nixosModules.networking-wireguard =
    {
      lib,
      config,
      ...
    }:
    let
      wireguard-prefs = config.host-prefs.wireguard;
      secrets = config.sops.secrets;
    in
    {
      config = lib.mkIf wireguard-prefs.enable {
        networking.firewall = {
          allowedUDPPorts = [ wireguard-prefs.port ];
          trustedInterfaces = [ "wg0" ];
        };

        networking.wireguard.interfaces."${wireguard-prefs.interfaceName}" = {
          ips = [ wireguard-prefs.address ];
          listenPort = wireguard-prefs.port;
          privateKeyFile = secrets.wireguard-key.path;
          peers = wireguard-prefs.peers;
        };
      };
    };
}
