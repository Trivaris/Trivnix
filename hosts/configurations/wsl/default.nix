{
  inputs,
  libExtra,
  usernames,
  hostname,
  ...
}:
libExtra.mkHostConfig {

  extraImports = [
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