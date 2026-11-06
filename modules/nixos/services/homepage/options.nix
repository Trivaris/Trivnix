{
  flake.nixosModules.services-homepage =
    { lib, trivnixLib, ... }:
    {
      options.hostPrefs.homepage = {
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Homepage service";
      };
    };
}
