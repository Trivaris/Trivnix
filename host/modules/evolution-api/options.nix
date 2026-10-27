{
  lib,
  ...
}:
{
  options.hostPrefs.evolution = {
    enable = lib.mkEnableOption "Evolution API service";
    reverseProxy = lib.mkReverseProxyOption;
  };
}
