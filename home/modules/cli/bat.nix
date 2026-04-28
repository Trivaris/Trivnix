{ config, lib, ... }:
let
  cliPrefs = config.userPrefs.cli;
in
{
  config = lib.mkIf cliPrefs.enable {
    programs.bat = {
      enable = true;
    };
  };
}
