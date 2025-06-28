{
  configname,
  inputs,
  config,
  usernames,
  lib,
  stateVersion,
  lib-extra,
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
      rootConfiguration { inherit config lib-extra; }
    else
      userConfiguration {
        inherit
          configname
          inputs
          config
          stateVersion
          lib-extra
          ;
        username = user;
      }
  ) usernames
)
