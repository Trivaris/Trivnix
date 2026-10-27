{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.hostPrefs.enableFingerPrintAuth = lib.mkEnableOption ''
    fingerprint authentication on the GDM login screen through fprintd.
    Use it when the host should offer fingerprint login in GNOME.
  '';

  config = lib.mkIf config.hostPrefs.enableFingerPrintAuth {
    services.fprintd = {
      enable = true;
      tod.enable = true;
      tod.driver = pkgs.libfprint-2-tod1-goodix;
    };
  };
}
