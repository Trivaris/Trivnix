{
  config,
  osConfig,
  lib,
  ...
}:
let
  prefs = config.userPrefs;
  starshipTheme = fromTOML(builtins.readFile (builtins.fetchurl {
    url = "https://starship.rs/presets/toml/nerd-font-symbols.toml";
    sha256 = "sha256:0f0pykrldyr5cxva278ahjs0xnqbm9gig7w8g850rswmiscc65fg";
  }));
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
          strategy = [ "match_prev_cmd" "history" "completion" ];
        };

        initContent = ''
          ${lib.optionalString prefs.cli.enable "fastfetch"}

          bindkey "^[[1;5D" backward-word
          bindkey "^[[1;5C" forward-word
        '';
      };
  };
}
