{
  flake.nixosModules.system-core =
    { lib, ... }:
    {
      options.host-prefs = {
        oldProfileDeleteInterval = lib.mkOption {
          type = lib.types.str;
          default = "3d";
          description = ''
            Maximum age for system profiles before garbage collection removes them.
            Passed directly to `nix-collect-garbage --delete-older-than`.
          '';
        };

        headless = lib.mkEnableOption "This host as a headless host without GUI features";
      };
    };
}
