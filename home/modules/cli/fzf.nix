{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
  isShell = shell: prefs.shell == shell;
in
{
  config = mkIf prefs.cli.enable {
    programs.fzf = {
      enable = true;
      defaultCommand = "fd --type f --exclude .git --follow --hidden";
      changeDirWidgetCommand = "fd --type d --exclude .git --follow --hidden";
      enableFishIntegration = isShell "fish";
      enableBashIntegration = isShell "bash";
      enableZshIntegration = isShell "zsh";
      defaultOptions = [
        "--preview='bat --color=always --style=numbers --line-range=:500 {}'"
        "--bind 'ctrl-/:toggle-preview'"
      ];
    };
  };
}
