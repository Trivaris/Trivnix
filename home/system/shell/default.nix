{
  config,
  osConfig,
  lib,
  ...
}:
let
  cliPrefs = config.userPrefs.cli;
in
{
  options.vars = {
    shellAbbreviations = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      readOnly = true;
      default = import ./_abbreviations.nix;
      description = "Shell abbreviations made available to the configured Zsh session";
    };

    shellFunctions = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      readOnly = true;
      default = import ./_functions.nix osConfig.hostInfos.configname;
      description = "Shell functions, including local check and rebuild helpers";
    };
  };

  config = {
    programs.zsh = {
      enable = true;
      autocd = true;
      shellAliases = config.vars.shellAbbreviations;
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

        ${lib.optionalString cliPrefs.enable "fastfetch"}
      '';
    };
  };
}
