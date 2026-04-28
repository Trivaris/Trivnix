{ config, lib, ... }:
let
  cliPrefs = config.userPrefs.cli;
in
{
  config = lib.mkIf cliPrefs.enable {
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
