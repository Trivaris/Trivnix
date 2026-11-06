{
  flake.nixosModules.services-matrix =
    {
      lib,
      trivnixLib,
      ...
    }:
    {
      options.host-prefs.matrix = {
        enable = lib.mkEnableOption "Matrix Conduit server";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
        name = lib.mkOption {
          type = lib.types.str;
          default = "matrix-server";
          description = "Public Matrix server name, defaulting to the reverse-proxy domain";
        };
      };
    };
}
