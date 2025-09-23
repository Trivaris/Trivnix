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
      (pipe allUserPrefs [
        builtins.attrValues
        (map (prefs: prefs.desktopEnvironment or ""))
        (builtins.elem "hyprland")
      ])
      {
        assertions = import ./assertions.nix { inherit hostInfos inputs; };

        programs.hyprland = {
          enable = true;
          package = inputs.hyprland.packages.${hostInfos.architecture}.hyprland;
          portalPackage = inputs.hyprland.packages.${hostInfos.architecture}.xdg-desktop-portal-hyprland;
        };

        security.pam.services.hyprlock = { };
      };
}
