{
  config,
  lib,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  config = lib.mkIf (prefs.displayManager == "sddm") {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
