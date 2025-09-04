{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (builtins.elem "zoxide" prefs.cli) {
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        character = {
          success_symbol = "[❯](green)";
          error_symbol = "[❯](red)";
        };
        directory = {
          style = "blue";
        };
      };
    };
  };
}
