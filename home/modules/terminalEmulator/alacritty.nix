{ config, lib, ... }:
let
  prefs = config.userPrefs;
in
{
  config = lib.mkIf (prefs.terminalEmulator == "alacritty") {
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
