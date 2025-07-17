{ libExtra, ... }:
{

  imports = [
    (libExtra.mkFlakePath /hosts/common)
    (libExtra.mkFlakePath /hosts/modules)
  ] ++ [
    ./hardware.nix
  ];

  config = {
    nixosModules = {
      bluetooth.enable = true;
      fish.enable = true;
      greet.enable = true;
      kde.enable = true;
      openssh.enable = true;
      printing.enable = true;
    };
  };

}
