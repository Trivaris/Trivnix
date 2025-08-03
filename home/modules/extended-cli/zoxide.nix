{ config, lib, ... }:
let
  cfg = config.homeConfig;
in
with lib;
{
  config = mkIf (builtins.elem "zoxide" cfg.extendedCli) {
    programs.zoxide = {
      enable = true;
    };
  };
}