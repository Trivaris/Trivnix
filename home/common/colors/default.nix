{
  lib,
  ...
}:
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

  options.colorschemes = colorschemes;

  options.colors = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = colorschemes.everforest-hard-dark;
    description = "Color palette";
  };

}
