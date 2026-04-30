{
  lib,
  ...
}:
{
  options.hostPrefs.evolution = {
    enable = lib.mkEnableOption "Evolution API";
    reverseProxy = lib.mkReverseProxyOption { defaultPort = 8079; };
  };
}