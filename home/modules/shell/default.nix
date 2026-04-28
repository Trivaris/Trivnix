{
  config,
  osConfig,
  lib,
  ...
}:
let
  cliPrefs = config.userPrefs.cli;
  starshipTheme = lib.pipe
  {
    url = "https://starship.rs/presets/toml/nerd-font-symbols.toml";
    sha256 = "sha256:1v4cda5zf5a9wirgxc1in6c40wrsa7pbjphb9ihkrgkwgp8jhj5q";
  }
  [
    builtins.fetchurl
    builtins.readFile
    fromTOML
    removeAttrs 
  ] [ "maven" ];
in
{
  options.vars = {
    shellAbbreviations = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      readOnly = true;
      default = import ./_abbreviations.nix;
    };

    shellFunctions = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      readOnly = true;
      default = import ./_functions.nix osConfig.hostInfos.configname;
    };
  };

  config = {
    programs.starship = {
      enable = true;
      settings = starshipTheme;
    };

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
