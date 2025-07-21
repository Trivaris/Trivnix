{
  config,
  lib,
  inputs,
  pkgs,
  libExtra,
  ...
}:
let
  cfg = config.nixosConfig;
in
with lib;
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  options.nixosConfig.minecraftServer = {
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
  };

  config = mkIf cfg.minecraftServer.enable {
    networking.firewall.allowedTCPPorts = [ cfg.minecraftServer.port ];

    services.minecraft-servers = {
      enable = true;
      eula = true;

      servers = builtins.listToAttrs (map (modpack: {
        name = modpack;
        value = let modpackPkg = pkgs.modpacks.${modpack}; in {
          enable = modpack == cfg.minecraftServer.modpack;
          package = pkgs.fabricServers."fabric-${modpackPkg.minecraftVersion}".override { loaderVersion = modpackPkg.fabricVersion; };

          serverProperties = {
            gamemode = "survival";
            difficulty = "hard";
            simulation-distance = 8;
            server-port = cfg.minecraftServer.port;
            whitelist = true;
          };

          files = modpackPkg.files;

          whitelist = {
            trivaris = "80ea6fa5-a1ac-4671-a23f-53cf1ab8a437";
            ingopin = "3ad93022-06db-475b-9519-75d81cca32bc";
          };

          jvmOpts = "-Xms8192M -Xmx8192M -XX:+UseG1GC";
        };
      }) (builtins.attrNames pkgs.modpacks) );
    };
  };
}
