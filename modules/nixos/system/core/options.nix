{
  flake.nixosModules.system-core =
    { lib, ... }:
    {
      options.host.preferences = {
        oldProfileDeleteInterval = lib.mkOption {
          type = lib.types.nonEmptyStr;
          default = "3d";
          description = ''
            Maximum age of system profiles before garbage collection removes them.
            This value is passed to `nix-collect-garbage --delete-older-than`.
          '';
        };

        headless = lib.mkEnableOption "headless operation without graphical features";
      };
    };
}
