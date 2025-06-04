{ inputs, outputs, lib, usernames, ... }:
{
  
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings.experimental-features = "nix-command flakes";
    settings.trusted-users = usernames ++ [ "root" ];
    gc.automatic = true;
    gc.dates = "daily";
    gc.options = "--delete-older-than 7d";
    settings.auto-optimise-store = true;
    optimise.automatic = true;
    registry = (lib.mapAttrs (_: flake: { inherit flake; })) (
      (lib.filterAttrs (_: lib.isType "flake")) inputs
    );
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };

}