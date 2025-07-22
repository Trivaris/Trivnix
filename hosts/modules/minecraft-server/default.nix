{
  config,
  lib,
  pkgs,
  libExtra,
  ...
}:
let
  cfg = config.nixosConfig;
in
with lib;
{
  options.nixosConfig.minecraftServer = import ./config.nix lib;

  config = mkIf (cfg.minecraftServer.enable) {
    services.minecraft-servers = {
      enable = true;
      eula = true;

      servers = builtins.listToAttrs (map (modpack: {
        name = modpack;
        value = let modpackPkg = pkgs.modpacks.${modpack}; in {
          enable = modpack == config.minecraftServer.modpack;
          openFirewall = true;

          package = pkgs.fabricServers."fabric-${modpackPkg.minecraftVersion}".override { loaderVersion = modpackPkg.fabricVersion; };
          files = {
            server-icon = libExtra.mkFlakePath /resources/minecraft-server-icon.png;
          } // modpackPkg.files;

          jvmOpts = "-Xms8192M -Xmx8192M -XX:+UseG1GC";

          serverProperties = {
            gamemode = "survival";
            difficulty = "hard";
            simulation-distance = 8;
            server-port = config.minecraftServer.port;
            enable-rcon = true;
            "rcon.port" = 25575;
            whitelist = true;
            max-tick-time = -1;
            motd = "Awake and Ready!";
          };

          whitelist = {
            trivaris = "80ea6fa5-a1ac-4671-a23f-53cf1ab8a437";
            ingopin = "3ad93022-06db-475b-9519-75d81cca32bc";
          };

          lazymc = {
            enable = true;
            config.time.sleep_after = 900;
            config.motd.sleeping = "💤 Server is napping! Connect to wake it.";
          };
        };
      }) (builtins.attrNames pkgs.modpacks) );
    };
  };
}
