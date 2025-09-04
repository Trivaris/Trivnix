{ lib, config, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (builtins.elem "btop" prefs.extendedCli) {
    programs.btop.enable = true;
  };
}
