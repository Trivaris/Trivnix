{ config, lib, ... }:
with lib;
{
  options.nixosConfig.kde.enable = mkEnableOption "Enable KDE Plasma";

  config = mkIf config.nixosConfig.kde.enable {
    services.desktopManager.plasma6.enable = true;
    stylix.targets.qt.platform = mkForce "qtct";
  };

}
