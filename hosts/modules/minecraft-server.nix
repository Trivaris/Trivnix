{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.nixosModules;
in
with lib;
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  options.nixosModules.minecraftServer = {
    enable = mkEnableOption "Minecraft Server";

    port = mkOption {
      type = types.int;
      default = 25565;
      description = "Internal Port used by the reverse Proxy";
    };

    domain = mkOption {
      type = types.str;
      description = "DNS name";
    };
  };

  config = mkIf cfg.minecraftServer.enable {
    services.minecraft-servers = {
      enable = true;
      eula = true;

      servers = {
        core-craft = {
          enable = true;
          package = pkgs.fabricServers.fabric-1_21_1;

          serverProperties = {
            gamemode = "surivival";
            difficulty = "hard";
            simulation-distance = 8;
            server-port = cfg.minecraftServer.port;
          };

          whitelist = {
            trivaris = "80ea6fa5-a1ac-4671-a23f-53cf1ab8a437";
          };
          
          symlinks =
            let
              modpack = pkgs.runCommand "core-craft" {
                nativeBuildInputs = [ pkgs.libarchive ];
              } ''
                mkdir -p $out
                bsdtar --no-same-permissions -xf ${pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/VABHuKKF/versions/lb3airvO/CoreCraft%202.1.mrpack";
                  sha256 = "sha256-x+yhLIW4Y9Hz/GpoMB5UAdwohPp7Fm50qc4B7Bk38UY=";
                }} -C $out
              '';

              index = builtins.fromJSON (builtins.readFile "${modpack}/modrinth.index.json");

              modsFromIndex = builtins.map (mod:
                pkgs.fetchurl {
                  url = if (builtins.isList (builtins.head mod.downloads))
                    then (builtins.head (builtins.head mod.downloads))
                    else (builtins.head mod.downloads);
                  sha512 = mod.hashes.sha512;
                }
              ) index.files;

              overrides = "${modpack}/overrides";
            in {
              # Fetched mods
              "mods" = pkgs.linkFarmFromDrvs "mods" modsFromIndex;

              # Direct copies from overrides folder
              "config" = overrides + "/config";
              "datapacks" = overrides + "/datapacks";
              "resourcepacks" = overrides + "/resourcepacks";
              "configureddefaults" = overrides + "/configureddefaults";
            };

          jvmOpts = "-Xms4092M -Xmx4092M -XX:+UseG1GC";
        };
      };
    };
  };
}
