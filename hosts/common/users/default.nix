{
  configname,
  inputs,
  config,
  usernames,
  lib,
  stateVersion,
  libExtra,
  ...
}:
let
  userConfiguration = import ./user.nix;
  rootConfiguration = import ./root.nix;
in
lib.mkMerge (
  [ { users.mutableUsers = false; } ]
  ++ builtins.map (
    user:
    if user == "root" then
      rootConfiguration { inherit config libExtra; }
    else
      userConfiguration {
        inherit
          configname
          inputs
          config
          stateVersion
          libExtra
          ;
        username = user;
      }
  ) usernames
)
