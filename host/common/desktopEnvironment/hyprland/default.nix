{
  inputs,
  pkgs,
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
  options.hostPrefs.hyprland = import ./options.nix lib;

  config = mkIf (prefs.desktopEnvironment.name == "hyprland") {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${hostInfos.architecture}.hyprland;
      portalPackage = inputs.hyprland.packages.${hostInfos.architecture}.xdg-desktop-portal-hyprland;
    };

    hostPrefs.desktopEnvironment.binary = "${pkgs.hyprland}/bin/Hyprland";
  };
}
