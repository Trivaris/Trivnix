{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.hyprland = import ./config.nix { };

  config = mkIf (prefs.desktopEnvironment == "hyprland") {
    programs.hyprland.enable = true;
  };
}
