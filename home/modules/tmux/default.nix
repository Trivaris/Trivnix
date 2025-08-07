{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.homeConfig;
in
{
  options.homeConfig.tmux.enable = mkEnableOption "Extended Tmux Configuration";

  config = mkIf cfg.tmux.enable {
    programs.tmux = {
      enable = true;
      prefix = "C-s";
      keyMode = "vi";

      plugins = [
        pkgs.tmuxPlugins.vim-tmux-navigator
      ];

      extraConfig = ''
        unbind q
        bind q source-file ~/.config/tmux/tmux.conf

        # Vi Keys
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R
      '';
    };
  };
}
