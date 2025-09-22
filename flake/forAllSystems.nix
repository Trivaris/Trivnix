{
  inputs,
  systems,
  lib,
}:
let
  inherit (lib) nameValuePair;
in
func:
builtins.listToAttrs (
  map (system: nameValuePair system (func (import inputs.nixpkgs { inherit system; }))) systems
)
