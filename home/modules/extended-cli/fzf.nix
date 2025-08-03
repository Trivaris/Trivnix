{ config, lib, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{
  config = mkIf (builtins.elem "fzf" cfg.extendedCli) {
    programs.fzf = {
      enable = true;

      defaultOptions = [
        "--preview='bat --color=always -n {}'"
        "--bind 'ctrl-/:toggle-preview'"
      ];

      defaultCommand = "fd --type f --exclude .git --follow --hidden";
      changeDirWidgetCommand = "fd --type d --exclude .git --follow --hidden";
    };
  };
}
