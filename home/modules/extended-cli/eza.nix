{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (builtins.elem "eza" prefs.extendedCli) {
    programs.eza = {
      enable = true;
      extraOptions = [
        "-l"
        "--icons"
        "--git"
        "-a"
      ];
    };
    programs.fish.functions.ls.body = "eza $argv";
  };
}
