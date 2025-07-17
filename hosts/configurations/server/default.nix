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
      fish.enable = true;
      openssh.enable = true;
      suwayomi.enable = true;
      vaultwarden = {
        enable = true;
        port = 25588;
        domain = "vault.trivaris.org";
        email = "cloudflare@tripple.lurdane.de";
      };
      nextcloud = {
        enable = false;
        domain = "cloud.trivaris.org";
        port = 25588;
        email = "cloudflare@tripple.lurdane.de";
      };
      keeweb = {
        enable = false;
        domain = "vault.trivaris.org";
        port = 25588;
        email = "cloudflare@tripple.lurdane.de";
      };
      sunshine = {
        enable = false;
        hostMac = "08:BF:B8:42:59:7C";
        hostIP = "192.168.178.70";
      };
      ddclient = {
        enable = true;
        zone = "trivaris.org";
        subdomains = [
          "vault"
          "cloud"
        ];
        email = "cloudflare@tripple.lurdane.de";
      };
    };
  };

}
