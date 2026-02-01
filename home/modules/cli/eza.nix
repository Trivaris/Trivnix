{ config, lib, ... }:
let
  prefs = config.userPrefs;
in
{
  config = lib.mkIf prefs.cli.enable {
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      extraOptions = [
        "-l"
        "--icons"
        "--git"
        "-a"
      ];
    };
  };
}
