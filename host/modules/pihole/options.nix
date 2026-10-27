{
  lib,
  ...
}:
{
  options.hostPrefs.piHole = {
    enable = lib.mkEnableOption "Pi-hole as a DNS sinkhole";
    reverseProxy = lib.mkReverseProxyOption;
  };
}
