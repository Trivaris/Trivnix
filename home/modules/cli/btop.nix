{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (builtins.elem "btop" prefs.cli.enabled) {
    programs.btop.enable = true;
  };
}
