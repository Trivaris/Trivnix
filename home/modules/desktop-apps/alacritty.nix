{ config, lib, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{
  config = mkIf (builtins.elem "alacritty" cfg.desktopApps) {
    programs.alacritty = {
      enable = true;
      
      settings = {
        font.normal.style = "Regular";

        cursor = {
          style = {
            shape = "Block";
            blinking = "On";
          };
          blink_interval = 500;
          blink_timeout = 0;
          unfocused_hollow = true;
        };
      };
    };
  };
}
