{
  host,
  ...
}: {

  imports = [ ./root.nix ] ++ builtins.map (user: import ./${user.name}.nix) host.users;

}
