{ libExtra, hostconfig, ... }:
{

  imports = [
    (libExtra.mkFlakePath /hosts/common)
    (libExtra.mkFlakePath /hosts/modules)
  ] ++ [
    ./hardware.nix
  ];

  config.nixosConfig = hostconfig.nixosConfig;

}
