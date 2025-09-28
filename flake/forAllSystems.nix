{
  inputs,
  lib,
  systems,
}:
let
  inherit (lib) nameValuePair;
in
func:
builtins.listToAttrs (
  map (
    system:
    nameValuePair system (func {
      pkgs = import inputs.nixpkgs { inherit system; };
    })
  ) systems
)
