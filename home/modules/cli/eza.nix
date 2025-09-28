{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
  name = "eza";
  isShell = shell: prefs.shell == shell;
in
{
  config = mkIf (builtins.elem name prefs.cli.enabled) {
    vars.cliReplacements = [ name ];
    programs.eza = {
      enable = true;
      enableFishIntegration = isShell "fish";
      enableBashIntegration = isShell "bash";
      enableZshIntegration = isShell "zsh";
      extraOptions = [
        "-l"
        "--icons"
        "--git"
        "-a"
      ];
    };
  };
}
