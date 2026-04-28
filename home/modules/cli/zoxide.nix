{ config, lib, ... }:
let
  cliPrefs = config.userPrefs.cli;
in
{
  config = lib.mkIf cliPrefs.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
