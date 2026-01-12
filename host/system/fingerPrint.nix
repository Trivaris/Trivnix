{
  config,
  lib,
  pkgs,
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
    services.fprintd = {
      enable = true;
      tod.enable = true;
      tod.driver = pkgs.libfprint-2-tod1-goodix;
    };
  };
}
