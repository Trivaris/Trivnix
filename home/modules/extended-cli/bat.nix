{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.userPrefs;
in
{
  config = mkIf (builtins.elem "bat" cfg.extendedCli) {
    programs.bat = {
      enable = true;
    };
    programs.fish.functions.cat.body = "bat $argv";
  };
}
