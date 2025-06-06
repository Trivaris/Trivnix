{
  usernames,
  hostname,
  ...
}:
{

  imports = [
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = builtins.head usernames;
  wsl.wslConf.network.hostname = hostname;

}
