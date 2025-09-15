{
  inputs,
  systems,
  lib,
}:
let
  inherit (lib) pipe nameValuePair;
in
func:
pipe systems [
  (map (system: nameValuePair system (func (import inputs.nixpkgs { inherit system; }))))
  builtins.listToAttrs
]
