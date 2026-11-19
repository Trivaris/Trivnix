{
  flake.nixosModules.networking-pihole =
    {
      lib,
      ...
    }:
    {
      options.host.preferences.pihole = {
        enable = lib.mkEnableOption "Pi-hole as a DNS sinkhole";
        wireguardOnly = lib.mkEnableOption "Pi-hole only for the Wireguard VPN";
        reverseProxy = lib.trivnix.mkReverseProxyOption;
      };
    };
}
