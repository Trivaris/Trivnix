{
  flake.nixosModules.services-matrix =
    {
      lib,
      ...
    }:
    {
      options.host-prefs.matrix = {
        enable = lib.mkEnableOption "Matrix Conduit server";
        reverseProxy = lib.trivnix.mkReverseProxyOption;
        name = lib.mkOption {
          type = lib.types.str;
          default = "matrix-server";
          description = "Public Matrix server name, defaulting to the reverse-proxy domain";
        };
      };
    };
}
