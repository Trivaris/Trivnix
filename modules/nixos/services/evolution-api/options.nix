{
  flake.nixosModules.services-evolution-api =
    {
      lib,
      ...
    }:
    {
      options.host.preferences.evolution = {
        enable = lib.mkEnableOption "Evolution API service";
        reverseProxy = lib.trivnix.mkReverseProxyOption;
      };
    };
}
