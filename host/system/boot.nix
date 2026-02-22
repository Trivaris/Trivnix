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
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [ "quiet" "udev.log_level=3" "systemd.show_status=auto" ];
    loader.timeout = 0;
  };
}