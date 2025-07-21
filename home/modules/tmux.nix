{ pkgs, config, lib, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{

  options.homeConfig.tmux = {
    enable = mkEnableOption "Extended Tmux Configuration";
  };

  config = mkIf cfg.tmux.enable {
    programs.tmux = {
      enable = true;
      prefix = "C-s";
      keyMode = "vi";

      plugins = with pkgs; [
        tmuxPlugins.vim-tmux-navigator
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
