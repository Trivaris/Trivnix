{
  config,
  lib,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  boot = lib.mkIf (!prefs.headless) {
    plymouth.enable = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
    loader = {
      timeout = 0;
      systemd-boot = {
        consoleMode = "keep";
        editor = false;
      };
    };
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=0"
      "systemd.show_status=false"
      "rd.systemd.show_status=false"
      "udev.log_level=0"
      "rd.udev.log_level=0"
      "vt.global_cursor_default=0"
    ];
  };
}
