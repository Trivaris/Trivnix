{ config, lib, ...}:
let 
  cfg = config.nixosConfig;
in 
with lib;
{

  options.nixosConfig.tui.enable = mkEnableOption "Enable CLI Tools related to TUIs";

  config = mkIf cfg.tui.enable {
    environment.systemPackages = with pkgs; [
      nchat
      instagram-cli
      gurk-rs
      discordo
    ];
  };

}