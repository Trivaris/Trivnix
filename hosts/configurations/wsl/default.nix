{
  inputs,
  lib-extra,
  usernames,
  hostname,
  ...
}:
lib-extra.mkHostConfig {

  extraImports = [
    ./hardware.nix
    inputs.nixos-wsl.nixosModules.default
  ];

  config = {
    nixosModules = {
      fish = true;
      openssh = true;
      kde = true;
    };

    sshPort = 2222;

    wsl = {
      enable = true;
      defaultUser = builtins.head usernames;
      wslConf.network.hostname = hostname;
    };
  };
  
}