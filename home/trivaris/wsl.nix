{ inputs, ... }:
let

  modules = [
    "base"
    "cli-utils"
    "fish"
    "fonts"
    "fzf"
    "nvim"
    "secrets"
    "vscodium"
  ];

in
{

  imports = [ ./credentials.nix ]
  ++ map(module: (inputs.self + "/modules/${module}.nix")) modules;

}
