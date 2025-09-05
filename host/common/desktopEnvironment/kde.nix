{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  config = mkIf (prefs.desktopEnvironment == "kde") {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager = {
        defaultSession = "plasma";
        sddm.wayland.compositor = "kwin";
      };
    };

    environment.plasma6.excludePackages = builtins.attrValues {
      inherit (pkgs.kdePackages)
        konsole
        elisa
        ;
    };

    environment.systemPackages = builtins.attrValues {
      inherit (pkgs.kdePackages)
        ksystemlog
        systemsettings
        plasma-browser-integration
        ;
    };

    qt.platformTheme = lib.mkForce "kde";
  };
}
