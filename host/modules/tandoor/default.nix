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
        if prefs.tandoor.reverseProxy.enable then "localhost" else prefs.tandoor.reverseProxy.domain;
      extraConfig = {
        MEDIA_ROOT = "/var/lib/tandoor-recipes/media/";
        DEBUG = "1";
        ALLOWED_HOSTS =
          if prefs.tandoor.reverseProxy.enable then prefs.tandoor.reverseProxy.domain else "localhost";
      };
    };
  };
}
