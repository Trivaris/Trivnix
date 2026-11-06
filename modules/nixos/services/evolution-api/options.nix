{
  flake.nixosModules.services-evolution-api =
    {
      lib,
      trivnixLib,
      ...
    }:
    {
      options.hostPrefs.evolution = {
        enable = lib.mkEnableOption "Evolution API service";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
      };
    };
}
