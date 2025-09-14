{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (builtins.elem "fzf" prefs.cli.enabled) {
    programs.fzf = {
      enable = true;
      defaultCommand = "fd --type f --exclude .git --follow --hidden";
      changeDirWidgetCommand = "fd --type d --exclude .git --follow --hidden";
      enableFishIntegration = prefs.shell == "fish";
      enableBashIntegration = prefs.shell == "bash";
      enableZshIntegration = prefs.shell == "zsh";

      defaultOptions = [
        "--preview='bat --color=always -n {}'"
        "--bind 'ctrl-/:toggle-preview'"
      ];
    };
  };
}
