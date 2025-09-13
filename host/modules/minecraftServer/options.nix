{
  mkReverseProxyOption,
  mkEnableOption,
  mkOption,
  types,
  pkgs,
}:
{
  enable = mkEnableOption "Enable Minecraft servers.";
  reverseProxy = mkReverseProxyOption { defaultPort = 25565; };

  modpack = mkOption {
    type = types.enum (builtins.attrNames pkgs.modpacks);
    example = "elysium-days";
    description = ''
      The modpack to deploy on the server. This must be one of the available
      modpacks defined in `pkgs.modpacks`.
    '';
  };

  serverIcon = mkOption {
    type = types.path;
    description = "Server Icon";
  };
}
