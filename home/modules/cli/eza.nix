{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (builtins.elem "eza" prefs.cli) {
    programs = {
      eza = {
        enable = true;
        enableFishIntegration = prefs.shell == "fish";
        enableBashIntegration = prefs.shell == "bash";
        enableZshIntegration = prefs.shell == "zsh";
        extraOptions = [
          "-l"
          "--icons"
          "--git"
          "-a"
        ];
      };

      fish.functions.ls.body = mkIf (prefs.shell == "fish") "eza $argv";
    };
  };
}
