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
        programs.hyprland.enable = true;

        xdg.portal = {
          enable = true;
          config.common.default = "*";
        };
      };
    };
}
