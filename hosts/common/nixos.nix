{
  inputs,
  outputs,
  lib,
  pkgs,
  libExtra,
  hostconfig,
  ...
}:
{
  time.timeZone = "Europe/Berlin";

  nixpkgs = {
    overlays = builtins.attrValues (outputs.overlays);
    config = libExtra.pkgsConfig;
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    optimise.automatic = true;
    gc.automatic = true;
    gc.dates = "daily";
    gc.options = "--delete-older-than 7d";
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = hostconfig.users ++ [ "root" ];
      auto-optimise-store = true;
      warn-dirty = false;
    };

    registry = (lib.mapAttrs (_: flake: { inherit flake; })) (
      (lib.filterAttrs (_: lib.isType "flake")) inputs
    );
  };
}
