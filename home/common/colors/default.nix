{ lib, config, ... }:
let
  colorschemes = {
    everforest-hard-dark = import ./everforest-hard-dark.nix;
    everforest-hard-light = import ./everforest-hard-light.nix;
    everforest-medium-dark = import ./everforest-medium-dark.nix;
    everforest-medium-light = import ./everforest-medium-light.nix;
    everforest-soft-dark = import ./everforest-soft-dark.nix;
    everforest-soft-light = import ./everforest-soft-light.nix;
  };
in
{
  options = {
    colorschemeName = lib.mkOption {
      type = lib.types.enum (builtins.attrNames colorschemes);
      default = "everforest-hard-dark";
      description = "Selected colorscheme name.";
    };

    colors = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      readOnly = true;
      description = "Computed color palette for the selected colorscheme.";
    };
  };

  config.colors = colorschemes.${config.colorschemeName};
}