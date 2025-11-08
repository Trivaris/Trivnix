{ config, lib, ... }:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
in
{
  config = mkIf prefs.cli.enable {
    programs.bat = {
      enable = true;
    };
  };
}
