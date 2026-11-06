{
  flake.nixosModules.system-ssh =
    { lib, ... }:
    let
      keyType = lib.types.path;

      keyOption = lib.mkOption {
        type = keyType;
        description = "Path to the public key file";
        readOnly = true;
      };

      commonSubmodule = lib.types.submodule {
        options = {
          ssh = lib.mkOption {
            type = lib.types.attrsOf keyType;
            description = "Guest SSH keys";
            default = { };
          };
        };
        freeformType = lib.types.attrsOf (lib.types.attrsOf keyType);
      };

      hostSubmodule = lib.types.submodule {
        options = {
          "host.pub" = keyOption;

          users = lib.mkOption {
            description = "User keys for this host";
            default = { };
            type = lib.types.attrsOf (lib.types.attrsOf keyType);
          };
        };
      };
    in
    {
      options.private.public-keys = {
        common = lib.mkOption {
          type = commonSubmodule;
        };

        hosts = lib.mkOption {
          type = lib.types.attrsOf hostSubmodule;
        };
      };
    };
}
