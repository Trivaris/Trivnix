{
  lib,
  pkgs,
  trivnixLib,
  ...
}:
{
  options.hostPrefs.minecraftServer = {
    reverseProxy = trivnixLib.mkReverseProxyOption { defaultPort = 25565; };

    enable = lib.mkEnableOption ''
      Provision the Minecraft server service backed by selected modpacks.
      Enable when this host should run the configured multiplayer world.
    '';

    modpack = lib.mkOption {
      type = lib.types.enum (builtins.attrNames pkgs.modpacks);
      example = "elysium-days";
      description = ''
        The modpack to deploy on the server. This must be one of the available
        modpacks defined in `pkgs.modpacks`.
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
