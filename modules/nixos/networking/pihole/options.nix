{
  flake.nixosModules.networking-pihole =
    {
      lib,
      ...
    }:
    {
      options.host-prefs.pihole = {
        enable = lib.mkEnableOption "Pi-hole as a DNS sinkhole";
        reverseProxy = lib.trivnix.mkReverseProxyOption;
      };
    };
}
