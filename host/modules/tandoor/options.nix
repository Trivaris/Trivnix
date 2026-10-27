{ lib, ... }:
{
  options.hostPrefs.tandoor = {
    reverseProxy = lib.mkReverseProxyOption;
    enable = lib.mkEnableOption ''
      Tandoor Recipes locally.
      It provides a self-hosted recipe manager behind the reverse proxy.
    '';
  };
}
