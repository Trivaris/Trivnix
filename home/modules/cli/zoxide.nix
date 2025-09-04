{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (builtins.elem "zoxide" prefs.cli) {
    programs.zoxide = {
      enable = true;
    };
  };
}
