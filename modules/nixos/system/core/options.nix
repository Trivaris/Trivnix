{
  flake.nixosModules.system-core =
    { lib, config, ... }:
    let
      allUserInfos = builtins.attrNames (
        builtins.mapAttrs (_: cfg: cfg.userInfos) config.home-manager.users
      );
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
          default = builtins.head allUserInfos;
          description = ''
            Primary user account considered owner of the host configuration.
            Used by modules such as autologin and service defaults needing a username.
          '';
        };

        headless = lib.mkEnableOption {
          description = "Disable GUI features";
        };
      };
    };
}
