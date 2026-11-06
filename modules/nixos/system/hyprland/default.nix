{ inputs, ... }:
{
  flake.nixosModules.system-hyprland =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (!config.hostPrefs.headless) {
        nixpkgs.overlays = [ inputs.hyprqt6engine.overlays.default ];
        environment.systemPackages = [ pkgs.sbctl ];
        security.pam.services.hyprlock = { };

        programs.hyprland = {
          enable = true;
          portalPackage = pkgs.xdg-desktop-portal-hyprland;
          package = pkgs.hyprland;
        };

        xdg.portal = {
          enable = true;
          extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
          config.common.default = "*";
        };

      };
    };
}
