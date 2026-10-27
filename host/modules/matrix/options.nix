{
  lib,
  ...
}:
{
  options.hostPrefs.matrix = {
    enable = lib.mkEnableOption "Matrix Conduit server";
    reverseProxy = lib.mkReverseProxyOption;
    name = lib.mkOption {
      type = lib.types.str;
      default = "matrix-server";
      description = "Public Matrix server name, defaulting to the reverse-proxy domain";
    };
  };
}
