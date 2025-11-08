{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
  isShell = shell: prefs.shell == shell;
in
{
  config = mkIf prefs.cli.enable {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = isShell "fish";
      enableBashIntegration = isShell "bash";
      enableZshIntegration = isShell "zsh";
    };
  };
}
