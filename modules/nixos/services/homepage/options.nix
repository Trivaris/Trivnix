{
  flake.nixosModules.services-homepage =
    { lib, trivnixLib, ... }:
    {
      options.hostPrefs.homepage = {
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;

        enable = lib.mkEnableOption ''
          Run the hompage service.
          Enable to provide a self-hosted Homepage instance behind a reverse proxy to manage all other services.
        '';
      };
    };
}
