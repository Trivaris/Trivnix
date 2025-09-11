{
  inputs,
  systems,
  lib,
}:
func:
lib.pipe systems [
  (map (system: lib.nameValuePair system (func (import inputs.nixpkgs { inherit system; }))))
  builtins.listToAttrs
]
