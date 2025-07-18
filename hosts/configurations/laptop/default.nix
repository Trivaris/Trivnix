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
      greet.enable = true;
      kde.enable = true;
      openssh.enable = true;
      printing.enable = true;
      codeServer = {
        enable = true;
        domain = "192.168.178.90";
        port = 7666;
      };
    };
  };

}
