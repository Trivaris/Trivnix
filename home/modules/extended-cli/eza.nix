{ config, lib, ... }:
let
  cfg = config.homeConfig;
in
with lib;
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