{
  lib,
  ...
}:
let
  colorschemes = {
    everforest-hard = import ./everforest-hard.nix;
  };
in
{

  options.colors = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = colorschemes.everforest-hard;
    description = "Color palette";
  };

}