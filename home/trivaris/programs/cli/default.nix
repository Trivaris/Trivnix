{
  pkgs,
  ...
}: {

  imports = [
    ./cli-packages.nix
    ./fish.nix
    ./fzf.nix
  ];

}