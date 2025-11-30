{ config, lib, ... }:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf prefs.tandoor.enable {
    services.tandoor-recipes = {
      enable = true;
      port = prefs.tandoor.reverseProxy.port;
      address = prefs.tandoor.reverseProxy.domain;
    };
  };
}