{
  mkEnableOption,
  mkOption,
  types,
  pkgs,
}:
{
  enable = mkEnableOption "Enable Minecraft servers.";

  domain = mkOption {
    type = types.str;
    description = ''
      FQDN to access the Minecraft Server instance.
      Can also be the ip Address of the server.
      Used in web configuration and TLS certificate issuance.
    '';
    example = "cloud.example.com";
  };

  port = mkOption {
    type = types.port;
    default = 25565;
    description = ''
      Port used by the Minecraft server.
    '';
  };

  modpack = mkOption {
    type = types.enum (builtins.attrNames pkgs.modpacks);
    example = "elysium-days";
    description = ''
      The modpack to deploy on the server. This must be one of the available
      modpacks defined in `pkgs.modpacks`.
    '';
  };
}
