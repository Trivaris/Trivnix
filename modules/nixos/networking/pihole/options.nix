{
  flake.nixosModules.networking-pihole =
    {
      lib,
      trivnixLib,
      ...
    }:
    {
      options.host-prefs.pihole = {
        enable = lib.mkEnableOption "Pi-hole as a DNS sinkhole";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
      };
    };
}
