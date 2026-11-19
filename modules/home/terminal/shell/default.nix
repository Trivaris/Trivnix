{
  flake.homeModules.terminal-shell =
    { config, lib, ... }:
    let
      cliPreferences = config.user.preferences.cli;
    in
    {
      programs.zsh = {
        enable = true;
        autocd = true;
        shellAliases = config.user.vars.shellAbbreviations;
        syntaxHighlighting.enable = true;

        autosuggestion = {
          enable = true;
          strategy = [
            "match_prev_cmd"
            "history"
            "completion"
          ];
        };

        initContent = ''
          bindkey "^[[1;5D" backward-word
          bindkey "^[[1;5C" forward-word

          ${lib.optionalString cliPreferences.enable "fastfetch"}
        '';
      };
    };
}
