{ config, lib, ... }:
let
  prefs = config.userPrefs;
in
{
  config = lib.mkIf (prefs.shell == "fish") {
    programs.fish = {
      enable = true;
      shellAbbrs = config.vars.shellAbbreviations;

      functions = config.vars.shellFunctions // {
        cat.body = "bat $argv";
        ls.body = "eza $argv";
        cd.body = "z $argv";
      };

      interactiveShellInit = ''
        set fish_greeting
        fastfetch
      '';
    };
  };
}
