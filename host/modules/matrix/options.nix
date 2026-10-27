{
  config,
  lib,
  ...
}:
{
  options.hostPrefs.matrix = {
    enable = lib.mkEnableOption "Matrix Conduit server";
    reverseProxy = lib.mkReverseProxyOption;
    name = lib.mkOption {
      type = lib.types.str;
      default = config.hostPrefs.matrix.reverseProxy.domain;
      description = "Public Matrix server name, defaulting to the reverse-proxy domain";
    };
  };
}
