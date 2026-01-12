{
  config,
  lib,
  pkgs,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.printing.enable = lib.mkEnableOption ''
    Configure CUPS printing with the bundled Samsung driver.
    Enable when the system must manage printers via the local spooler.
  '';

  config = lib.mkIf prefs.printing.enable {
    services.printing = {
      enable = true;
      drivers = [ pkgs.samsung-unified-linux-driver ];
    };

    systemd.services.cups-browsed = {
      enable = false;
      unitConfig.Mask = true;
    };
  };
}
