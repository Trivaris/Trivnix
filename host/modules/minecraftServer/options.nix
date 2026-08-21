{ lib, pkgs, ... }:
{
  options.hostPrefs.minecraftServer = {
    enable = lib.mkEnableOption ''
      Provision the Minecraft server service backed by selected modpacks.
      Enable when this host should run the configured multiplayer world.
    '';

    package = lib.mkPackageOption pkgs "Minecraft Server" {
      default = [ "minecraftServers" "vanilla" ];
      example = "minecraft-server-fabric";
    };

    workDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/minecraft-server";
      description = "The directory where the Minecraft server data will be stored.";
    };

    extraFlags = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Extra Flags passed to the Minecraft server executable";
    };

  };
}
