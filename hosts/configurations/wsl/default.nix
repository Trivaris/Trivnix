{
  inputs,
  libExtra,
  usernames,
  hostname,
  ...
}:
{

  imports = [
    (libExtra.mkFlakePath /hosts/common)
    (libExtra.mkFlakePath /hosts/modules)
  ] ++ [
    ./hardware.nix
    inputs.nixos-wsl.nixosModules.default
  ];

  config = {
    nixosModules = {
      fish.enable = true;
      openssh = {
        enable = true;
        port = 2222;
      };
    };


    wsl = {
      enable = true;
      defaultUser = builtins.head usernames;
      wslConf.network.hostname = hostname;
    };
  };
  
}