{
  flake.homeModules.system-core =
    {
      lib,
      ...
    }:
    {
      options.user-infos = {
        name = lib.mkOption {
          type = lib.types.str;
          description = "The name of the user.";
        };
        hashedPassword = lib.mkOption {
          type = lib.types.str;
          description = "The hashed password for the user.";
        };
        uid = lib.mkOption {
          type = lib.types.int;
          description = "The user ID (UID) for the user.";
        };
      };
    };
}
