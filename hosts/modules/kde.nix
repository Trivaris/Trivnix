{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules;
in
with lib;
{

  options.nixosModules.kde = mkEnableOption "KDE";

  config = mkIf cfg.kde {
    services = {
      desktopManager.plasma6.enable = true;

      displayManager.sddm.enable = true;

      displayManager.sddm.wayland.enable = true;
    };

    environment.systemPackages = with pkgs; [
      wayland-utils
    ];
  };

}
