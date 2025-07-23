lib:
with lib;
{
  enable = mkEnableOption "Enable Minecraft servers.";

  port = mkOption {
    type = types.int;
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