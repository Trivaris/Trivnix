{ config, lib, ... }:
let
  prefs = config.userPrefs;
in
{
  config = lib.mkIf prefs.cli.enable {
    programs.fzf = {
      enable = true;
      defaultCommand = "fd --type f --exclude .git --follow --hidden";
      changeDirWidgetCommand = "fd --type d --exclude .git --follow --hidden";
      enableZshIntegration = true;
      defaultOptions = [
        "--preview='bat --color=always --style=numbers --line-range=:500 {}'"
        "--bind 'ctrl-/:toggle-preview'"
      ];
    };
  };
}
