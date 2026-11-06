{
  imports = [
    ./starship.nix
  ];

  flake.homeModules.terminal-shell =
    {
      config,
      osConfig,
      lib,
      ...
    }:
    let
      cli-prefs = config.user-prefs.cli;
    in
    {
      options.vars = {
        shell-abbreviations = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          readOnly = true;
          default = import ./_abbreviations.nix;
          description = "Shell abbreviations made available to the configured Zsh session";
        };

        shell-functions = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          readOnly = true;
          default = import ./_functions.nix osConfig.host-infos.configname;
          description = "Shell functions, including local check and rebuild helpers";
        };
      };

      config = {
        programs.zsh = {
          enable = true;
          autocd = true;
          shellAliases = config.vars.shell-abbreviations;
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

            ${lib.optionalString cli-prefs.enable "fastfetch"}
          '';
        };
      };
    };
}
