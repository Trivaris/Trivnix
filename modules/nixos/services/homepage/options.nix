{
  flake.nixosModules.services-homepage =
    { lib, ... }:
    {
      options.host.preferences.homepage = {
        reverseProxy = lib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption "Homepage service";
      };
    };
}
