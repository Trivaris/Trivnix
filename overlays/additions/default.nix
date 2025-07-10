{ inputs, pkgs }:
{
  rmatrix = pkgs.callPackage ./rmatrix.nix { inherit inputs pkgs; };
  rbonsai = pkgs.callPackage ./rbonsai.nix { inherit inputs pkgs; };
  suwayomi-server-update = pkgs.callPackage ./suwayomi { inherit inputs pkgs; };
}
