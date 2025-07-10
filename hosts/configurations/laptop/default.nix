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
      bluetooth = true;
      fish = true;
      greet = true;
      kde = true;
      openssh = true;
      printing = true;
    };
  };

}
