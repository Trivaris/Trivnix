{
  lib,
  pkgs,
  inputs,
  allUserInfos,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    pipe
    mkDefault
    mapAttrs
    filterAttrs
    isType
    ;
in
{
  options.hostPrefs.mainUser = mkOption {
    type = types.str;
    default = pipe allUserInfos [
      builtins.attrNames
      builtins.head
    ];
    description = "The main user of this host. Used by sevices like autlogin if enabled";
  };

  config = {
    time.timeZone = "Europe/Berlin";
    nixowos.enable = true;

    nix = {
      package = mkDefault pkgs.nix;
      optimise.automatic = true;
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 3d";
      };

      settings = {
        experimental-features = "nix-command flakes pipe-operators";
        trusted-users = (builtins.attrNames allUserInfos) ++ [ "root" ];
        auto-optimise-store = true;
        warn-dirty = false;
      };

      registry = (mapAttrs (_: flake: { inherit flake; })) ((filterAttrs (_: isType "flake")) inputs);
    };
  };
}
