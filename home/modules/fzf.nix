{ pkgs, config, lib, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{

  options.homeConfig.fzf = {
    enable = mkEnableOption "Extended Fzf Configuration";
  };

  config = mkIf cfg.fzf.enable {
    programs.fzf = {
      enable = true;

      colors = {
        "fg" = "#f8f8f2";
        "bg" = "#282a36";
        "hl" = "#bd93f9";
        "fg+" = "#f8f8f2";
        "bg+" = "#44475a";
        "hl+" = "#bd93f9";
        "info" = "#ffb86c";
        "prompt" = "#50fa7b";
        "pointer" = "#ff79c6";
        "marker" = "#ff79c6";
        "spinner" = "#ffb86c";
        "header" = "#6272a4";
      };

      defaultOptions = [
        "--preview='bat --color=always -n {}'"
        "--bind 'ctrl-/:toggle-preview'"
      ];

      defaultCommand = "fd --type f --exclude .git --follow --hidden";
      changeDirWidgetCommand = "fd --type d --exclude .git --follow --hidden";
    };
  };

}
