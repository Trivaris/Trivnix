{ inputs, ... }:
let
  optionals = [ "all" ];
in
{

  imports = [
    ../common
    ./hardware.nix
  ] ++ map (optional: (inputs.self + "/hosts/common/optional/${optional}.nix")) optionals;

}
