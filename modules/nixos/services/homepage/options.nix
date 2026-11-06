{
  flake.nixosModules.services-homepage =
    { lib, trivnixLib, ... }:
    {
      options.host-prefs.homepage = {
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Homepage service";
      };
    };
}
