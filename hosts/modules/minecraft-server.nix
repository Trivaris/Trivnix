{
  config,
  lib,
  inputs,
  pkgs,
  libExtra,
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
    networking.firewall.allowedTCPPorts = [ cfg.minecraftServer.port ];

    services.minecraft-servers = {
      enable = true;
      eula = true;

      servers = {
        elysium-days =
          let
            elysium = libExtra.mkModpack { inherit pkgs; modpack = pkgs.elysium-days.src; };
          in
          {
          enable = true;
          package = pkgs.fabricServers.fabric-1_20_1;

          serverProperties = {
            gamemode = "surivival";
            difficulty = "hard";
            simulation-distance = 8;
            server-port = cfg.minecraftServer.port;
          };

          symlinks = elysium.symlinks;

          whitelist = {
            trivaris = "80ea6fa5-a1ac-4671-a23f-53cf1ab8a437";
          };

          jvmOpts = "-Xms4092M -Xmx4092M -XX:+UseG1GC";
        };
      };
    };
  };
}
