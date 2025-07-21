  {
    inputs,
    outputs,
    config,
    lib,
    libExtra,
    pkgs,
    userconfigs,
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
  let
    userconfig = userconfigs.${username}; 
  in
    mkUserConfig {
      inherit
        inputs
        outputs
        config
        lib
        libExtra
        userconfig
        username
        hostconfig
        configname
        hosts;
    }
  ) hostconfig.users;
in
lib.mkMerge (
  [ { users.mutableUsers = false; users.defaultUserShell = pkgs.fish; } ]
  ++
  userConfigurations
  ++
  [ rootConfiguration ]
)
