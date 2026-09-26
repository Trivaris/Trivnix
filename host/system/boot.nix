{
  config,
  pkgs,
  lib,
  ...
}:
{
  boot = lib.mkIf (!config.hostPrefs.headless) {
    plymouth = {
      enable = true;
      theme = "spin";
      themePackages = [ (pkgs.adi1090x-plymouth-themes.override { selected_themes = [ "spin" ]; }) ];
      extraConfig = ''
        [Daemon]
        DeviceScale=2
      '';
    };
    consoleLogLevel = 3;
    initrd.verbose = false;
    loader.timeout = 0;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];
  };
}
