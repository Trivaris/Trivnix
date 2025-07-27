{ config, lib, pkgs, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{
  options.homeConfig.waydroid.enable = mkEnableOption "Enable Android Emulator [NOT Production ready]";

  config = mkIf cfg.waydroid.enable {
    home.packages = with pkgs; [
      waydroid
    ];
    
    systemd.user.services.init-waydroid = {
      Unit = {
        Description = "Initialize Waydroid with GAPPS";
        After = [ "network-online.target" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.sudo}/bin/sudo ${pkgs.waydroid}/bin/waydroid init \
            -c https://waydroid.bardia.tech/OTA/system \
            -v https://waydroid.bardia.tech/OTA/vendor \
            -s GAPPS -f
        '';
        RemainAfterExit = true;
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
