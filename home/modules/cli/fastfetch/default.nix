{
  config,
  isNixos,
  lib,
  osConfig,
  pkgs,
  trivnixLib,
  ...
}:
let
  inherit (lib) mkIf;
  prefs = config.userPrefs;
  scheme = (if isNixos then osConfig else config).stylix.base16Scheme;
  getColor = trivnixLib.getColor { inherit pkgs scheme; };
in
{
  config = mkIf (builtins.elem "fastfetch" prefs.cli.enabled) {
    programs.fastfetch = {
      enable = true;
      settings = {
        "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
        logo.source = "nixos_old_small";
        modules = import ./modules.nix;
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
