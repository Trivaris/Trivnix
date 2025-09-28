{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  prefs = config.userPrefs;
in
{
  config = mkIf (prefs.shell == "fish") {
    programs.fish = {
      enable = true;
      shellAbbrs = config.vars.shellAbbreviations;

      functions = mkMerge [
        config.vars.shellFunctions
        (mkIf (builtins.elem "bat" prefs.cli.replaceDefaults) { cat.body = "bat $argv"; })
        (mkIf (builtins.elem "eza" prefs.cli.replaceDefaults) { ls.body = "eza $argv"; })
        (mkIf (builtins.elem "zoxide" prefs.cli.replaceDefaults) { cd.body = "z $argv"; })
      ];

      interactiveShellInit = ''
        set fish_greeting
        ${if (builtins.elem "fastfetch" prefs.cli.enabled) then "fastfetch" else ""}
      '';
    };
  };
}
