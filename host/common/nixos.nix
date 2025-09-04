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
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

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
