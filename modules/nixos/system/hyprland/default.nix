{
  flake.nixosModules.system-hyprland =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (!config.host.preferences.headless) {
        programs.hyprland.enable = true;
        services.gvfs.enable = true;
        environment.systemPackages = [ pkgs.sbctl ];
        security.pam.services = {
          hyprlock = { };
          quickshell.fprintAuth = false;
          "quickshell-fingerprint" = {
            fprintAuth = config.host.preferences.fingerPrintAuth;
            unixAuth = false;
          };
        };

        xdg.portal = {
          enable = true;
          config.common.default = "*";
        };
      };
    };
}
