{ config, lib, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{
  options.homeConfig.alacritty.enable = mkEnableOption "Enable Alacritty Terminal Emulator";

  config = mkIf (cfg.alacritty.enable) {
    programs.alacritty = {
      enable = true;
      
      settings = {
        font.normal.style = "Regular";

        cursor = {
          style = {
            shape = "Block";          # or "Underline" / "Beam"
            blinking = "On";          # enables blinking
          };
          blink_interval = 500;        # ms between blinks
          blink_timeout = 0;           # 0 = never stop blinking
          unfocused_hollow = true;     # hollow cursor when window is unfocused
        };
      };
    };
  };
}
