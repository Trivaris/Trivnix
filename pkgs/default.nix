{ inputs, pkgs }:
{
    rmatrix = pkgs.callPackage ./rmatrix.nix { inherit inputs pkgs; };
    rbonsai = pkgs.callPackage ./rbonsai.nix { inherit inputs pkgs; };
    adbutils = pkgs.callPackage ./adbutils.nix { inherit inputs pkgs; };
    adbautoplayer = pkgs.callPackage ./adbautoplayer.nix { inherit inputs pkgs; };
}