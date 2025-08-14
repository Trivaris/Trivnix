{
  config,
  lib,
  libExtra,
  pkgs,
  allUserPrefs,
  ...
}:
let
  mkUserConfig = import ./user.nix;

  rootConfig = import ./root.nix {
    inherit
      config
      lib
      libExtra
      ;
  };

  userConfigs = map (username:
    let
      userPrefs = allUserPrefs.${username};
    in
    mkUserConfig { inherit userPrefs lib libExtra; }
  ) allUserPrefs.users;
in
lib.mkMerge (
  [
    {
      users.mutableUsers = false;
      users.defaultUserShell = pkgs.fish;
    }
  ]
  ++ userConfigs
  ++ [ rootConfig ]
)
