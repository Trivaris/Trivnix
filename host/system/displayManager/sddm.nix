{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  config = mkIf (prefs.displayManager == "sddm") {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    environment.systemPackages = mkIf (prefs.desktopEnvironment == "kde") [
      pkgs.kdePackages.sddm-kcm
    ];
  };
}
