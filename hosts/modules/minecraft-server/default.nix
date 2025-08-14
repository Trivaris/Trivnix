{
  config,
  lib,
  pkgs,
  libExtra,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.hostprefs;
in
{
  options.hostprefs.minecraftServer = import ./config.nix {
    inherit (lib) mkEnableOption mkOption types;
    inherit pkgs;
  };

  config = mkIf (cfg.minecraftServer.enable) {
    services.minecraft-servers = {
      enable = true;
      eula = true;

      servers =
        let
          inherit (cfg.minecraftServer) modpack;
          modpackPkg = pkgs.modpacks.${modpack};
        in
        {
          ${modpack} = {
            enable = true;
            openFirewall = true;

            package = pkgs.fabricServers."fabric-${modpackPkg.minecraftVersion}".override {
              loaderVersion = modpackPkg.fabricVersion;
            };

            files = {
              server-icon = libExtra.mkFlakePath /resources/minecraft-server-icon.png;
            }
            // modpackPkg.files;

            jvmOpts = "-Xms8192M -Xmx8192M -XX:+UseG1GC";

            serverProperties = {
              gamemode = "survival";
              difficulty = "hard";
              simulation-distance = 8;
              server-port = cfg.minecraftServer.port;
              whitelist = true;
              max-tick-time = -1;
              "enable-rcon" = true;
              "rcon.port" = cfg.minecraftServer.port - 2;
              motd = "Awake and Ready!";
            };

            whitelist = {
              trivaris = "80ea6fa5-a1ac-4671-a23f-53cf1ab8a437";
              ingopin = "3ad93022-06db-475b-9519-75d81cca32bc";
            };

            lazymc = {
              enable = true;

              package =
                let
                  oldLazyMCPkgs = import (builtins.fetchTarball {
                    url = "https://github.com/NixOS/nixpkgs/archive/336eda0d07dc5e2be1f923990ad9fdb6bc8e28e3.tar.gz";
                    sha256 = "sha256:0v8vnmgw7cifsp5irib1wkc0bpxzqcarlv8mdybk6dck5m7p10lr";
                  }) { inherit (pkgs) system; };
                in
                oldLazyMCPkgs.lazymc;

              config = {
                public.address = "${cfg.minecraftServer.domain}:${toString (cfg.minecraftServer.port + 1)}";

                server.start_timeout = 180;
                server.stop_timeout = 60;

                time.sleep_after = 900;
                time.minimum_online_time = 120;

                motd.sleeping = "💤 Server is napping! Connect to wake it.";
                motd.starting = "§2☻ Server is starting...\n§7⌛ Please wait...";
                motd.stopping = "☠ Server going to sleep...\n⌛ Please wait...";
                motd.from_server = true;

                join.hold.timeout = 60;

                advanced.rewrite_server_properties = true;

                rcon = {
                  enabled = true;
                  port = cfg.minecraftServer.port - 2;
                  password = "secure-password";
                  randomize_password = true;
                };
              };
            };
          };
        };
    };
  };
}
