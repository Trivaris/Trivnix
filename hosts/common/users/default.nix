{ usernames, ... }:
{

  imports = [ ./root.nix ] ++ builtins.map (user: import ./${user}.nix) usernames;

  users.mutableUsers = false;
}
