{
  inputs,
  lib-extra,
  usernames,
  hostname,
  ...
}:
{

  imports = [
    (lib-extra.mkFlakePath /hosts/common)
    (lib-extra.mkFlakePath /hosts/modules)
  ] ++ [
    ./hardware.nix
    inputs.nixos-wsl.nixosModules.default
  ];

  config = {
    nixosModules = {
      fish = true;
      openssh = true;
    };

    sshPort = 2222;

    wsl = {
      enable = true;
      defaultUser = builtins.head usernames;
      wslConf.network.hostname = hostname;
    };
  };
  
}