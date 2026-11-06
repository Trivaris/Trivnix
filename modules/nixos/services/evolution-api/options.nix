{
  flake.nixosModules.services-evolution-api =
    {
      lib,
      ...
    }:
    {
      options.host-prefs.evolution = {
        enable = lib.mkEnableOption "Evolution API service";
        reverseProxy = lib.trivnix.mkReverseProxyOption;
      };
    };
}
