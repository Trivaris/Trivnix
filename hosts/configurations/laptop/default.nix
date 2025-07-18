{ libExtra, ... }:
{

  imports = [
    (libExtra.mkFlakePath /hosts/common)
    (libExtra.mkFlakePath /hosts/modules)
  ] ++ [
    ./hardware.nix
    ./secrets.nix
  ];

  config = {
    nixosModules = {
      bluetooth.enable = true;
      fish.enable = true;
      kde.enable = true;
      openssh.enable = true;
      printing.enable = true;
    };
  };

}
