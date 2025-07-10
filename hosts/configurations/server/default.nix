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
      fish = true;
      openssh = true;
      suwayomi = true;
      # vaultwarden = true;
    };
  };

}
