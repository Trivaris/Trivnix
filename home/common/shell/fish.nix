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
  config = mkIf (prefs.shell == "fish") {
    programs.fish = {
      enable = true;
      shellAbbrs = config.vars.shellAbbreviations;
      functions = config.vars.shellFunctions;
      interactiveShellInit = ''
        set fish_greeting
        ${if (builtins.elem "fastfetch" prefs.cli.enabled) then "fastfetch" else ""}
      '';
    };
  };
}
