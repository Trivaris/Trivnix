{
  pkgs,
  trivnixLib,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
  scheme = config.stylix.base16Scheme;
  getColor = trivnixLib.getColor { inherit pkgs scheme; };
in
{
  config = mkIf (builtins.elem "fastfetch" prefs.cli) {
    programs.fastfetch = {
      enable = true;
      package = pkgs.fastfetch;

      settings = {
        "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

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

        modules = import ./modules.nix { inherit getColor; };
      };
    };
  };
}
