{ inputs, ... }:
let

  optionals = [
    "custom-packages"
    "fish"
  ];

in
{

  imports = [
    ./hardware.nix
    ./configuration.nix
    ../common
  ]
  ++ map(optional: (inputs.self + "/hosts/common/optional/${optional}.nix")) optionals;

}
