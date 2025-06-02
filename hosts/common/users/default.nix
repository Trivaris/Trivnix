{
  users,
  ...
}:
{

  imports = [ ./root.nix ] ++ builtins.map (user: import ./${user}.nix) users;

}
