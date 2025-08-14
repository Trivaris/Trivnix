{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.userPrefs;
in
{
  config = mkIf (builtins.elem "zoxide" cfg.extendedCli) {
    programs.zoxide = {
      enable = true;
    };
  };
}
