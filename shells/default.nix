{
  perSystem = { pkgs, ... }: {
    devShells.default = import ./_shell.nix { inherit pkgs; };
  };
}
