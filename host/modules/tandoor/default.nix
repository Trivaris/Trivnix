{ config, lib, ... }:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf prefs.tandoor.enable {
    services.tandoor-recipes = {
      inherit (prefs.tandoor.reverseProxy) port;
      enable = true;
      address =
        if prefs.tandoor.reverseProxy.enable then prefs.tandoor.reverseProxy.domain else "localhost";
      extraConfig.MEDIA_ROOT = "/var/lib/tandoor-recipes/media/";
    };
  };
}
