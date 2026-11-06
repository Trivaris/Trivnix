{
  flake.nixosModules.system-core =
    {
      config,
      lib,
      ...
    }:
    {
      boot = lib.mkIf (!config.host-prefs.headless) {
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
    };
}
