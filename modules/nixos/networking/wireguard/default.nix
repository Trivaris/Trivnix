{
  flake.nixosModules.networking-wireguard =
    {
      lib,
      config,
      ...
    }:
    let
      wireguardPreferences = config.host.preferences.wireguard;
      secrets = config.sops.secrets;
    in
    {
      config = lib.mkIf wireguardPreferences.enable {
        networking.firewall = {
          allowedUDPPorts = [ wireguardPreferences.port ];
          trustedInterfaces = [ wireguardPreferences.interfaceName ];
        };

        networking.wireguard.interfaces."${wireguardPreferences.interfaceName}" = {
          ips = [ wireguardPreferences.address ];
          listenPort = wireguardPreferences.port;
          privateKeyFile = secrets.wireguard-key.path;
          peers = wireguardPreferences.peers;
        };
      };
    };
}
