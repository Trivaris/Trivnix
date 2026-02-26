{
  config,
  lib,
  ...
}:
{
  options.hostPrefs.matrix = {
    enable = lib.mkEnableOption "Enable the Matrix Conduit Server";
    reverseProxy = lib.mkReverseProxyOption { defaultPort = 6167; };
    name = lib.mkOption {
      type = lib.types.str;
      default = config.hostPrefs.matrix.reverseProxy.domain;
    };
  };
}
