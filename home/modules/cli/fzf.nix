{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
  isShell = shell: prefs.shell == shell;
in
{
  config = mkIf (builtins.elem "fzf" prefs.cli.enabled) {
    programs.fzf = {
      enable = true;
      defaultCommand = "fd --type f --exclude .git --follow --hidden";
      changeDirWidgetCommand = "fd --type d --exclude .git --follow --hidden";
      enableFishIntegration = isShell "fish";
      enableBashIntegration = isShell "bash";
      enableZshIntegration = isShell "zsh";

      defaultOptions = [
        "--preview='bat --color=always -n {}'"
        "--bind 'ctrl-/:toggle-preview'"
      ];
    };
  };
}
