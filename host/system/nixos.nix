{
  allUserInfos,
  config,
  lib,
  pkgs,
  ...
}:
let
  prefs = config.hostPrefs;
in
{
  options.hostPrefs = {
    oldProfileDeleteInterval = lib.mkOption {
      type = lib.types.str;
      default = "3d";
      description = ''
        Maximum age for system profiles before garbage collection removes them.
        Passed directly to `nix-collect-garbage --delete-older-than`.
      '';
    };

    mainUser = lib.mkOption {
      type = lib.types.str;
      default = builtins.head (builtins.attrNames allUserInfos);
      description = ''
        Primary user account considered owner of the host configuration.
        Used by modules such as autologin and service defaults needing a username.
      '';
    };
  };

  config = {
    time.timeZone = "Europe/Berlin";
    networking.networkmanager.plugins = [ pkgs.networkmanager-strongswan ];
    programs.nix-ld.enable = true;

    nix = {
      package = lib.mkDefault pkgs.nix;
      optimise.automatic = true;

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
    };
  };
}
