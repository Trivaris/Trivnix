{ inputs, pkgs }:
{
  rmatrix = pkgs.callPackage ./rmatrix.nix { inherit inputs pkgs; };
  rbonsai = pkgs.callPackage ./rbonsai.nix { inherit inputs pkgs; };
  adbautoplayer = pkgs.callPackage ./adbautoplayer.nix { inherit inputs pkgs; };
}
