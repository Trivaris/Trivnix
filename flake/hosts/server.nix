{
  name = "trivserver";
  stateVersion = "25.05";
  hardwareKey = false;
  ip = "192.168.178.75";
  architecture = "x86_64-linux";

  users.trivaris = {
    name = "trivaris";
    homeModules = {
      cli-utils.enable = true;
      fish.enable = true;
      git.email = "github@tripple.lurdane.de";
    };
  };
  
  nixosModules = {
    fish.enable = true;
    openssh.enable = true;

    reverseProxy = {
      enable = true;
      email = "cloudflare@tripple.lurdane.de";
      zone = "trivaris.org";
      port = 25588;
      extraDomains = [ "minecraft.trivaris.org" ];
      ddnsTime = "04:15";
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

    minecraftServer = {
      enable = true;
      domain = "minecraft.trivaris.org";
    };
  };
}