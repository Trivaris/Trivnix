{
  config,
  lib,
  ...
}:
let
  prefs = config.userPrefs;
  theme = config.themingPrefs.theme;
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
            keys = theme.base0D;
            title = theme.base0D;
            separator = theme.base03;
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
