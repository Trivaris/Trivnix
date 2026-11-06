{
  flake.nixosModules.networking-pihole =
    {
      lib,
      trivnixLib,
      ...
    }:
    {
      options.hostPrefs.piHole = {
        enable = lib.mkEnableOption "Pi Hole, a DNS Sink";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
      };
    };
}
