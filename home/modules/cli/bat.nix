{ config, lib, ... }:
let
  prefs = config.userPrefs;
in
{
  config = lib.mkIf prefs.cli.enable {
    programs.bat = {
      enable = true;
    };
  };
}
