{
  flake.nixosModules.networking-pihole =
    {
      lib,
      ...
    }:
    {
      options.host.preferences.pihole = {
        enable = lib.mkEnableOption "Pi-hole as a DNS sinkhole";
        reverseProxy = lib.trivnix.mkReverseProxyOption;
      };
    };
}
