{ lib-extra, ... }:
{

  imports = [
    (lib-extra.mkFlakePath /hosts/common)
    (lib-extra.mkFlakePath /hosts/modules)
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
