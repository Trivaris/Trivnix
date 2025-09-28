{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (prefs.terminalEmulator == "kitty") {
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
