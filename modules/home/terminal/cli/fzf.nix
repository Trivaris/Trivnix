{
  flake.homeModules.terminal-cli =
    { config, lib, ... }:
    let
      cliPreferences = config.user.preferences.cli;
    in
    {
      config = lib.mkIf cliPreferences.enable {
        programs.fzf = {
          enable = true;
          defaultCommand = "fd --type f --exclude .git --follow --hidden";
          changeDirWidget.command = "fd --type d --exclude .git --follow --hidden";
          enableZshIntegration = true;
          defaultOptions = [
            "--preview='bat --color=always --style=numbers --line-range=:500 {}'"
            "--bind 'ctrl-/:toggle-preview'"
          ];
        };
      };
    };
}
