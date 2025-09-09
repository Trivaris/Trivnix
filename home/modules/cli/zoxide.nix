{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (builtins.elem "zoxide" prefs.cli) {
    programs = {
      zoxide = {
        enable = true;
        enableFishIntegration = prefs.shell == "fish";
        enableBashIntegration = prefs.shell == "bash";
        enableZshIntegration = prefs.shell == "zsh";
      };

      fish.functions.cd.body = "z \"$argv\"";
    };
  };
}
