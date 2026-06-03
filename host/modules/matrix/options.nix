{
  config,
  lib,
  ...
}:
{
  options.hostPrefs.matrix = {
    enable = lib.mkEnableOption "Enable the Matrix Conduit Server";
    reverseProxy = lib.mkReverseProxyOption;
    name = lib.mkOption {
      type = lib.types.str;
      default = config.hostPrefs.matrix.reverseProxy.domain;
    };
  };
}
