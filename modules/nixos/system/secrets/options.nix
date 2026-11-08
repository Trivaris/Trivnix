{
  flake.nixosModules.system-secrets =
    { lib, ... }:
    {
      options.host.private.secrets = {
        commonSecretsFile = lib.mkOption {
          type = lib.types.pathInStore;
          description = "";
        };
        hostSecretsFile = lib.mkOption {
          type = lib.types.pathInStore;
          description = "";
        };
      };
    };
}
