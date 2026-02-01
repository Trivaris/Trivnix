{ lib, ... }:
{
  options.hostPrefs.tandoor = {
    reverseProxy = lib.mkReverseProxyOption { defaultPort = 8099; };
    enable = lib.mkEnableOption ''
      Run the hompage service.
      Enable to provide a self-hosted Homepage instance behind a reverse proxy to manage all other services.
    '';
  };
}
