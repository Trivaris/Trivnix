{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixosModules;
in
with lib;
{

  options.nixosModules.kde.enable = mkEnableOption "KDE Plasma";

  config = mkIf cfg.kde.enable {
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    programs.dconf.enable = true;
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd exec start-kde";
          user = "trivaris";
        };
      };
    };
  };

}
