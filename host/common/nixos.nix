{
  lib,
  pkgs,
  inputs,
  config,
  allUserInfos,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkDefault
    mapAttrs
    filterAttrs
    isType
    ;

  prefs = config.hostPrefs;
in
{
  options.hostPrefs = {
    oldProfileDeleteInterval = mkOption {
      type = types.str;
      default = "3d";
      description = ''
        Maximum age for system profiles before garbage collection removes them.
        Passed directly to `nix-collect-garbage --delete-older-than`.
      '';
    };

    mainUser = mkOption {
      type = types.str;
      default = builtins.head (builtins.attrNames allUserInfos);
      description = ''
        Primary user account considered owner of the host configuration.
        Used by modules such as autologin and service defaults needing a username.
      '';
    };
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
        options = "--delete-older-than ${prefs.oldProfileDeleteInterval}";
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
