{
  config,
  lib,
  ...
}:
{
  boot = lib.mkIf (!config.hostPrefs.headless) {
    plymouth = {
      enable = true;
      theme = "bgrt";
    };

    consoleLogLevel = 3;
    loader.timeout = 0;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];
  };
}
