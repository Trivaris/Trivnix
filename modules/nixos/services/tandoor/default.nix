{
  flake.nixosModules.services-tandoor =
    { config, lib, ... }:
    let
      tandoorPreferences = config.host.preferences.tandoor;
    in
    {
      config = lib.mkIf tandoorPreferences.enable {
        services.tandoor-recipes = {
          inherit (tandoorPreferences.reverseProxy) port;
          enable = true;
          address =
            if tandoorPreferences.reverseProxy.enable then
              "localhost"
            else
              tandoorPreferences.reverseProxy.domain;
          extraConfig = {
            MEDIA_ROOT = "/var/lib/tandoor-recipes/media/";
            DEBUG = "1";
            ALLOWED_HOSTS =
              if tandoorPreferences.reverseProxy.enable then
                tandoorPreferences.reverseProxy.domain
              else
                "localhost";
          };
        };
      };
    };
}
