{
  inputs,
  hostInfos,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  config = mkIf (prefs.desktopEnvironment == "hyprland") {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${hostInfos.architecture}.hyprland;
      portalPackage = inputs.hyprland.packages.${hostInfos.architecture}.xdg-desktop-portal-hyprland;
    };
  };
}
