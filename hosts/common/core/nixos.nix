{
  inputs,
  lib,
  usernames,
  pkgs,
  pkgsLib,
  ...
}:
{

  nixpkgs = {
    overlays = pkgsLib.overlayList;
    config = pkgsLib.pkgsConfig;
  };

  nix = {
    package = lib.mkDefault pkgs.nix;

    gc.automatic = true;
    gc.dates = "daily";
    gc.options = "--delete-older-than 7d";

    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = usernames ++ [ "root" ];
      auto-optimise-store = true;
      warn-dirty = false;
    };

    optimise.automatic = true;
    registry = (lib.mapAttrs (_: flake: { inherit flake; })) (
      (lib.filterAttrs (_: lib.isType "flake")) inputs
    );
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };

}
