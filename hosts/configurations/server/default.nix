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

      reverseProxy = {
        enable = true;
        email = "cloudflare@tripple.lurdane.de";
        zone = "trivaris.org";
        port = 25588;
      };

      vaultwarden = {
        enable = true;
        domain = "vault.trivaris.org";
      };

      nextcloud = {
        enable = true;
        domain = "cloud.trivaris.org";
      };

      codeServer = {
        enable = true;
        domain = "code.trivaris.org";
      };

      suwayomi = {
        enable = true;
        domain = "manga.trivaris.org";
      };
    };
  };

}
