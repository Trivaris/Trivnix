{ config, lib, ... }:
let
  tandoorPrefs = config.hostPrefs.tandoor;
in
{
  config = lib.mkIf tandoorPrefs.enable {
    services.tandoor-recipes = {
      inherit (tandoorPrefs.reverseProxy) port;
      enable = true;
      address =
        if tandoorPrefs.reverseProxy.enable then "localhost" else tandoorPrefs.reverseProxy.domain;
      extraConfig = {
        MEDIA_ROOT = "/var/lib/tandoor-recipes/media/";
        DEBUG = "1";
        ALLOWED_HOSTS =
          if tandoorPrefs.reverseProxy.enable then tandoorPrefs.reverseProxy.domain else "localhost";
      };
    };
  };
}
