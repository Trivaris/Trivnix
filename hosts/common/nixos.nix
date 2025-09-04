{
  inputs,
  lib,
  pkgs,
  allUserInfos,
  ...
}:
{
  time.timeZone = "Europe/Berlin";

  nix = {
    package = lib.mkDefault pkgs.nix;
    optimise.automatic = true;
    gc.automatic = true;
    gc.dates = "daily";
    gc.options = "--delete-older-than 7d";
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    settings = {
      experimental-features = "nix-command flakes pipe-operators";
      trusted-users = (builtins.attrNames allUserInfos) ++ [ "root" ];
      auto-optimise-store = true;
      warn-dirty = false;
    };

    registry = (lib.mapAttrs (_: flake: { inherit flake; })) (
      (lib.filterAttrs (_: lib.isType "flake")) inputs
    );
  };
}
