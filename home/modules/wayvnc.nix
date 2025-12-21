{
  config,
  lib,
  ...
}:
let
  prefs = config.userPrefs;
in
{
  options.userPrefs.wayvnc.enable = lib.mkEnableOption ''
    Enable remote desktop access via WayVNC.
    Requires a Wayland session (e.g., Sway, Hyprland).
  '';

  config = lib.mkIf (prefs.wayvnc.enable && prefs.desktopEnvironment == "hyprland") {
    services.wayvnc = {
      enable = true;
      autoStart = true;
      settings = {
        address = "0.0.0.0";
        port = 5900;
      };
    };
  };
}
