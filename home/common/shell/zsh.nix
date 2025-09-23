{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (prefs.shell == "zsh") {
    programs.zsh = {
      enable = true;
      shellAliases = config.vars.shellAbbreviations;
      siteFunctions = config.vars.shellFunctions;
      initContent = ''
        ${if (builtins.elem "fastfetch" prefs.cli.enabled) then "fastfetch" else ""}
      '';
    };
  };
}
