{ config, lib, ... }:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf prefs.tandoor.enable {
    services.tandoor-recipes = {
      inherit (prefs.tandoor.reverseProxy) port;
      enable = true;
      address = prefs.tandoor.reverseProxy.domain;
    };
  };
}
