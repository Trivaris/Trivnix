{
  lib,
  inputs,
  hostInfos,
  allUserPrefs,
  ...
}:
let
  inherit (lib) mkIf pipe;
in
{

  config =
    mkIf
      (builtins.elem "hyprland" (
        pipe allUserPrefs [
          builtins.attrValues
          (map (prefs: prefs.desktopEnvironment or ""))
        ]
      ))
      {
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

        security.pam.services.hyprlock = { };
      };
}
