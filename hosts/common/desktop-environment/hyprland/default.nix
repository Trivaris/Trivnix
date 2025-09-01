{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.hostPrefs;
in
{
  options.hostPrefs.hyprland = import ./config.nix { };

  config = mkIf (cfg.desktopEnvironment == "hyprland") {
    programs.hyprland.enable = true;
  };
}
