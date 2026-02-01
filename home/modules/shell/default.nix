{
  config,
  osConfig,
  lib,
  ...
}:
let
  prefs = config.userPrefs;
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
    programs.starship.enable = true;
    programs.zsh = {
      enable = true;
      autocd = true;
      shellAliases = config.vars.shellAbbreviations;
      siteFunctions = config.vars.shellFunctions;
      autosuggestion.enable = true;
      autosuggestion.strategy = [ "completion" ];
      syntaxHighlighting.enable = true;
      initContent = ''
        ${lib.optionalString prefs.cli.enable "fastfetch"}
      '';
    };
  };
}
