{ config, lib, ... }:
let
  prefs = config.userPrefs;
  isShell = shell: prefs.shell == shell;
in
{
  config = lib.mkIf prefs.cli.enable {
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
