{
  flake.nixosModules.networking-pihole =
    {
      lib,
      trivnixLib,
      ...
    }:
    {
      options.hostPrefs.piHole = {
        enable = lib.mkEnableOption "Pi-hole as a DNS sinkhole";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
      };
    };
}
