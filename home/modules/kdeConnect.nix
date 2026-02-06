{ lib, osConfig, ... }:
let
  prefs = osConfig.hostPrefs;
in
{
  config = lib.mkIf prefs.kdeConnect.enable {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
