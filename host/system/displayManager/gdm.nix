{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.gdm.enableFingerprintLogin = mkEnableOption ''
    Enable fingerprint authentication on the GDM login screen by turning on fprintd.
    Activate this when the host should offer fingerprint login in GNOME.
  '';

  config = mkIf (prefs.displayManager == "gdm") {
    services = {
      displayManager.gdm.enable = true;
      fprintd.enable = prefs.gdm.enableFingerprintLogin;
    };
  };
}
