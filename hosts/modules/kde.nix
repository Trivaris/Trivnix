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

  options.nixosModules.kde = mkEnableOption "KDE Plasma";

  config = mkIf cfg.kde {
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    programs.dconf.enable = true;
  };

}
