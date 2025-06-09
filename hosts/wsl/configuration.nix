{
  usernames,
  hostname,
  inputs,
  ...
}:
{

  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl.enable = true;
  wsl.defaultUser = builtins.head usernames;
  wsl.wslConf.network.hostname = hostname;

}
