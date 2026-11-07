{
  flake.nixosModules.services-tandoor =
    { config, lib, ... }:
    let
      tandoor-prefs = config.host-prefs.tandoor;
    in
    {
      config = lib.mkIf tandoor-prefs.enable {
        services.tandoor-recipes = {
          inherit (tandoor-prefs.reverseProxy) port;
          enable = true;
          address =
            if tandoor-prefs.reverseProxy.enable then "localhost" else tandoor-prefs.reverseProxy.domain;
          extraConfig = {
            MEDIA_ROOT = "/var/lib/tandoor-recipes/media/";
            DEBUG = "1";
            ALLOWED_HOSTS =
              if tandoor-prefs.reverseProxy.enable then tandoor-prefs.reverseProxy.domain else "localhost";
          };
        };
      };
    };
}
