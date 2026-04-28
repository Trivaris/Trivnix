{ config, lib, ... }:
let
  glancesPrefs = config.hostPrefs.glances;
in
{
  config = lib.mkIf glancesPrefs.enable {
    services.glances = {
      inherit (glancesPrefs) port;
      enable = true;
      extraArgs = [
        "--webserver"
        "--disable-webui"
      ];
    };
  };
}
