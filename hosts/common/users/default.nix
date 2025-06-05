{ configname, inputs, config, usernames, lib, stateVersion, ... }:
let
  userConfiguration = import ./user.nix;
  rootConfiguration = import ./root.nix;
in
lib.mkMerge (
  [{ users.mutableUsers = false; }] ++ 
  builtins.map
    (user:
      if user == "root"
      then
        rootConfiguration { inherit inputs config; }
      else
        userConfiguration {
          inherit
            configname
            inputs
            config
            stateVersion;
          username = user;
        }
    ) 
    usernames
)
