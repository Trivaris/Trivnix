{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkForce mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.enableFingerPrintAuth = mkEnableOption ''
    Enable fingerprint authentication on the GDM login screen by turning on fprintd.
    Activate this when the host should offer fingerprint login in GNOME.
  '';

  config = mkIf prefs.enableFingerPrintAuth {
    services.fprintd.enable = true;
    security.pam.services = {
      login.fprintAuth = mkForce true;
      sudo.fprintAuth = mkForce true;
    };
  };
}
