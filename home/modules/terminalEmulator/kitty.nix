{ config, lib, ... }:
let
  prefs = config.userPrefs;
in
{
  config = lib.mkIf (prefs.terminalEmulator == "kitty") {
    programs.kitty = {
      enable = true;
      enableGitIntegration = true;
      shellIntegration = {
        enableFishIntegration = prefs.shell == "fish";
        enableBashIntegration = prefs.shell == "bash";
        enableZshIntegration = prefs.shell == "zsh";
      };
    };
  };
}
