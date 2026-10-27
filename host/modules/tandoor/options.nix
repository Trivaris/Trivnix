{ lib, ... }:
{
  options.hostPrefs.tandoor = {
    reverseProxy = lib.mkReverseProxyOption;
    enable = lib.mkEnableOption "Tandoor Recipes, a self-hosted recipe manager";
  };
}
