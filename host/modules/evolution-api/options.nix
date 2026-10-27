{
  lib,
  ...
}:
{
  options.hostPrefs.evolution = {
    enable = lib.mkEnableOption "the Evolution API service";
    reverseProxy = lib.mkReverseProxyOption;
  };
}
