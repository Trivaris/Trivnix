{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf (builtins.elem "bat" prefs.cli) {
    programs = {
      bat.enable = true;
      fish.functions.cat.body = mkIf (prefs.shell == "fish") "bat $argv";
    };
  };
}
