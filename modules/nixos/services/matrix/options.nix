{
  flake.nixosModules.services-matrix =
    {
      config,
      lib,
      trivnixLib,
      ...
    }:
    {
      options.hostPrefs.matrix = {
        enable = lib.mkEnableOption "Enable the Matrix Conduit Server";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
        name = lib.mkOption {
          type = lib.types.str;
          default = config.hostPrefs.matrix.reverseProxy.domain;
        };
      };
    };
}
