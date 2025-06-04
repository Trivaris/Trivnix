{ lib, inputs, ... }:
let
  jsonPath = inputs.self + "/resources/material-green.json";
  jsonraw = builtins.readFile jsonPath;
  jsonText = builtins.unsafeDiscardStringContext jsonraw;
  json = builtins.fromJSON jsonText;
in
{

  options.colors = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
    default = json.colors;
    description = "Color palette loaded from JSON";
  };

  config = { };

}
