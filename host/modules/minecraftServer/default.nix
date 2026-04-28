{
  config,
  lib,
  pkgs,
  ...
}:
let
  minecraftServerPrefs = config.hostPrefs.minecraftServer;
in
{
  config = lib.mkIf minecraftServerPrefs.enable {
    services.minecraft-servers = {
      enable = true;
      eula = true;

      servers =
        let
          modpackPkg = pkgs.${minecraftServerPrefs.modpack};
        in
        {
          ${minecraftServerPrefs.modpack} = {
            enable = true;
            openFirewall = !minecraftServerPrefs.reverseProxy.enable;
            jvmOpts = "-Xms8192M -Xmx8192M -XX:+UseG1GC";

            package = pkgs.fabricServers."fabric-${modpackPkg.minecraftVersion}".override {
              loaderVersion = modpackPkg.fabricVersion;
            };

            files = modpackPkg.files // {
              server-icon = minecraftServerPrefs.serverIcon;
            };

            serverProperties = {
              gamemode = "survival";
              difficulty = "hard";
              simulation-distance = 8;
              server-port = minecraftServerPrefs.reverseProxy.port;
              whitelist = true;
              max-tick-time = -1;
              enable-rcon = true;
              "rcon.port" = minecraftServerPrefs.reverseProxy.port - 2;
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
                  oldLazyMCPkgs = import (fetchTarball {
                    url = "https://github.com/NixOS/nixpkgs/archive/336eda0d07dc5e2be1f923990ad9fdb6bc8e28e3.tar.gz";
                    sha256 = "sha256:0v8vnmgw7cifsp5irib1wkc0bpxzqcarlv8mdybk6dck5m7p10lr";
                  }) { system = config.hostInfos.architecture; };
                in
                oldLazyMCPkgs.lazymc;

              config = {
                join.hold.timeout = 60;
                advanced.rewrite_server_properties = true;

                public.address = "${minecraftServerPrefs.reverseProxy.domain}:${
                  toString (minecraftServerPrefs.reverseProxy.port + 1)
                }";

                time = {
                  sleep_after = 900;
                  minimum_online_time = 120;
                };

                server = {
                  start_timeout = 180;
                  stop_timeout = 60;
                };

                motd = {
                  sleeping = "💤 Server is napping! Connect to wake it.";
                  starting = "§2☻ Server is starting...\n§7⌛ Please wait...";
                  stopping = "☠ Server going to sleep...\n⌛ Please wait...";
                  from_server = true;
                };

                rcon = {
                  enabled = true;
                  port = minecraftServerPrefs.reverseProxy.port - 2;
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
