{
  flake.nixosModules.system-core =
    { lib, ... }:
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
          description = ''
            Primary user account considered owner of the host configuration.
            Used by modules such as autologin and service defaults needing a username.
          '';
        };

        headless = lib.mkEnableOption "This host as a headless host without GUI features";
      };
    };
}
