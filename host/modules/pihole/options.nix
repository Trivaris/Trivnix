{
  lib,
  ...
}:
{
  options.hostPrefs.piHole = {
    enable = lib.mkEnableOption "Pi Hole, a DNS Sink";
    reverseProxy = lib.mkReverseProxyOption;
  };
}