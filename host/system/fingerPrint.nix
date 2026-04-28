{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.hostPrefs.enableFingerPrintAuth = lib.mkEnableOption ''
    Enable fingerprint authentication on the GDM login screen by turning on fprintd.
    Activate this when the host should offer fingerprint login in GNOME.
  '';

  config = lib.mkIf config.hostPrefs.enableFingerPrintAuth {
    services.fprintd = {
      enable = true;
      tod.enable = true;
      tod.driver = pkgs.libfprint-2-tod1-goodix;
    };
  };
}
