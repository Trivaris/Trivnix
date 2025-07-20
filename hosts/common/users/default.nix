  {
    inputs,
    config,
    lib,
    libExtra,

    configname,
    hostconfig,
    hosts,

    ...
  }:
  let
    mkUserConfig = import ./user.nix;

    rootConfiguration = import ./root.nix {
      inherit
        config
        lib
        libExtra;
      inherit
        hostconfig
        hosts;
    };

  userConfigurations = map (username:
    mkUserConfig {
      inherit
        inputs
        config
        lib
        libExtra
        configname
        hostconfig
        hosts
        username;
    }
  ) hostconfig.users;
in
lib.mkMerge (
  [ { users.mutableUsers = false; } ]
  ++
  userConfigurations
  ++
  [ rootConfiguration ]
)
