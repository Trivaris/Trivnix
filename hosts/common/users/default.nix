{
  configname,
  inputs,
  config,
  usernames,
  lib,
  stateVersion,
  libExtra,
  users,
  hosts,
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
      rootConfiguration { inherit config libExtra hosts users lib; }
    else
      userConfiguration {
        inherit
          configname
          inputs
          config
          stateVersion
          libExtra
          users
          hosts
          lib
          ;
        username = user;
      }
  ) usernames
)
