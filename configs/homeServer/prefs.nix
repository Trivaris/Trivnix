common:
{
  openssh.enable = true;

  reverseProxy = {
    enable = true;
    email = "cloudflare@tripple.lurdane.de";
    zone = "trivaris.org";
    port = 25588;
    ddnsTime = "04:15";
    extraDomains = [
      "minecraft.trivaris.org"
    ];
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

  sunshine = {
    enable = true;
    domain = "sunshine.trivaris.org";
    hostMac = "08:bf:b8:42:59:7c";
  };

  minecraftServer = {
    enable = false;
    domain = "minecraft.trivaris.org";
    modpack = "rising-legends";
  };

  inherit (common) stylix;
}