{ config, lib, ... }:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf prefs.glances.enable {
    services.glances = {
      inherit (prefs.glances) port;
      enable = true;
      extraArgs = [
        "--webserver"
        "--disable-webui"
      ];
    };
  };
}
