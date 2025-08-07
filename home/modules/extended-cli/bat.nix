{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.homeConfig;
in
{
  config = mkIf (builtins.elem "bat" cfg.extendedCli) {
    programs.bat = {
      enable = true;
    };
    programs.fish.functions.cat.body = "bat $argv";
  };
}
