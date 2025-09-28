{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.glances = import ./options.nix {
    inherit (lib) mkEnableOption mkOption types;
  };

  config = mkIf prefs.glances.enable {
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
