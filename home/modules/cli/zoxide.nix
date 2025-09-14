{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (builtins.elem "zoxide" prefs.cli.enabled) {
    programs = {
      zoxide = {
        enable = true;
        enableFishIntegration = prefs.shell == "fish";
        enableBashIntegration = prefs.shell == "bash";
        enableZshIntegration = prefs.shell == "zsh";
      };

      fish.functions.cd.body = mkIf (prefs.shell == "fish") "z \"$argv\"";
    };

    vars.defaultReplacementModules = [ "zoxide" ];
  };
}
