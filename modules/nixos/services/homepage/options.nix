{
  flake.nixosModules.services-homepage =
    { lib, ... }:
    {
      options.host-prefs.homepage = {
        reverseProxy = lib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Homepage service";
      };
    };
}
