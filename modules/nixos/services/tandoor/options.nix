{
  flake.nixosModules.services-tandoor =
    { lib, trivnixLib, ... }:
    {
      options.hostPrefs.tandoor = {
        reverseProxy = trivnixLib.trivnix.mkReverseProxyOption;
        enable = lib.mkEnableOption ''
          Run the hompage service.
          Enable to provide a self-hosted Homepage instance behind a reverse proxy to manage all other services.
        '';
      };
    };
}
