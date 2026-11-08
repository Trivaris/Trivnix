{
  flake.homeModules.system-secrets = { lib, ... }: {
    options.user.private.secrets = {
      commonSecretsFile = lib.mkOption {
        type = lib.types.pathInStore;
        description = "";
      };
      userSecretsFile = lib.mkOption {
        type = lib.types.pathInStore;
        description = "";
      };
    };
  };
}
