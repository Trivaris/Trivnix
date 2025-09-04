{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (builtins.elem "zoxide" prefs.extendedCli) {
    programs.zoxide = {
      enable = true;
    };
  };
}
