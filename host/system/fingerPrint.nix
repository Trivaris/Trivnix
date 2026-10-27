{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.hostPrefs.enableFingerPrintAuth = lib.mkEnableOption "Fingerprint authentication for sudo";

  config = lib.mkIf config.hostPrefs.enableFingerPrintAuth {
    services.fprintd = {
      enable = true;
      tod.enable = true;
      tod.driver = pkgs.libfprint-2-tod1-goodix;
    };
  };
}
