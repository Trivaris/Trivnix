{
  flake.nixosModules.services-evolution-api =
    {
      lib,
      trivnixLib,
      ...
    }:
    {
      options.host-prefs.evolution = {
        enable = lib.mkEnableOption "Evolution API service";
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
      };
    };
}
