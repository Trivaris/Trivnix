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
      fish = true;
      openssh = true;
      sunshine = true;
      suwayomi = true;
    };
  };

}
