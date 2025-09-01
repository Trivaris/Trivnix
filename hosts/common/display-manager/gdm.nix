{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.hostPrefs;
in
{
  config = mkIf (cfg.displayManager == "gdm") {
    services.displayManager.gdm = {
      enable = true;
    };
  };
}
