{
  flake.homeModules.terminal-shell = { lib, osConfig, ... }: {
    options.user.vars = {
      shellAbbreviations = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        readOnly = true;
        default = import ./_abbreviations.nix;
        description = "Shell abbreviations made available to the configured Zsh session";
      };

      shellFunctions = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        readOnly = true;
        default = import ./_functions.nix osConfig.host.info.configName;
        description = "Shell functions, including local check and rebuild helpers";
      };
    };
  };
}
