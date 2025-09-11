{
  config,
  lib,
  pkgs,
  inputs,
  hostInfos,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.hostPrefs;
in
{
  options.hostPrefs.hyprland = import ./options.nix lib;

  config = mkIf (prefs.desktopEnvironment == "hyprland") {
    assertions = [
      {
        assertion = builtins.hasAttr hostInfos.architecture inputs.hyprland.packages;
        message = "Hyprland: architecture ${hostInfos.architecture} not available in inputs.hyprland.packages";
      }
    ];

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${hostInfos.architecture}.hyprland;
      portalPackage = inputs.hyprland.packages.${hostInfos.architecture}.xdg-desktop-portal-hyprland;
    };

    vars.desktopEnvironmentBinary = "${pkgs.hyprland}/bin/Hyprland";
  };
}
