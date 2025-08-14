{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.userPrefs;
in
{
  config = mkIf (builtins.elem "eza" cfg.extendedCli) {
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
