{
  config,
  lib,
  trivnixLib,
  pkgs,
  ...
}:
let
  prefs = config.userPrefs;
  scheme = config.stylixPrefs.theme;
  getColor = trivnixLib.getColor pkgs scheme;
in
{
  config = lib.mkIf prefs.cli.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
        logo.source = "nixos_old_small";
        modules = import ./_modules.nix;
        display = {
          separator = " ";
          brightColor = true;
          disableLinewrap = true;
          hideCursor = true;

          color = {
            keys = getColor "base0D";
            title = getColor "base0D";
            separator = getColor "base03";
          };

          key = {
            type = "both";
            width = 15;
            paddingLeft = 1;
          };
        };
      };
    };
  };
}
