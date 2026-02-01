{ config, lib, ... }:
let
  prefs = config.userPrefs;
in
{
  config = lib.mkIf prefs.cli.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
