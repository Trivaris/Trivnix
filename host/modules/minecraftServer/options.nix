{ lib, ... }:
{
  options.hostPrefs.minecraftServer = {
    reverseProxy = lib.mkReverseProxyOption { defaultPort = 25565; };

    enable = lib.mkEnableOption ''
      Provision the Minecraft server service backed by selected modpacks.
      Enable when this host should run the configured multiplayer world.
    '';

    modpack = lib.mkOption {
      type = lib.types.str;
      example = "elysium-days";
      description = ''
        The modpack to deploy on the server. This must be a valid modpack pkg.
      '';
    };

    serverIcon = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path to the 64x64 PNG used as the Minecraft server icon.
        The file is copied into the modpack directory during deployment.
      '';
    };
  };
}
