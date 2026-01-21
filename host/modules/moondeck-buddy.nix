{
  config,
  lib,
  pkgs,
  ...
}:
let
  prefs = config.hostPrefs;
  jsonFormat = pkgs.formats.json { };
  configFile = jsonFormat.generate "moondeckbuddy-config.json" (
    prefs.moondeck.settings
    // {
      port = prefs.moondeck.port;
    }
  );
in
{
  options.hostPrefs.moondeck = {
    enable = lib.mkEnableOption "MoonDeck Buddy companion for Sunshine";
    openFirewall = lib.mkEnableOption "Open firewall for MoonDeck Buddy";
    package = lib.mkPackageOption pkgs "moondeck-buddy" { };
    port = lib.mkOption {
      type = lib.types.port;
      default = 59999;
      description = "The port MoonDeck Buddy listens on.";
    };

    infoPort = lib.mkOption {
      type = lib.types.port;
      default = 47989;
      description = "The port MoonDeck Buddy uses to fetch Sunshine info.";
    };

    settings = lib.mkOption {
      type = jsonFormat.type;
      default = { };
      description = "Additional settings for ~/.config/moondeckbuddy/config.json";
    };
  };

  config = lib.mkIf prefs.moondeck.enable {
    environment.systemPackages = [ prefs.moondeck.package ];

    networking.firewall = lib.mkIf prefs.moondeck.openFirewall {
      allowedTCPPorts = [
        prefs.moondeck.port
        prefs.moondeck.infoPort
      ];
      allowedUDPPorts = [
        prefs.moondeck.port
        prefs.moondeck.infoPort
      ];
    };

    systemd.user.services.moondeck-buddy = {
      description = "MoonDeck Buddy Companion Service";

      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      preStart = ''
        mkdir -p %h/.config/moondeckbuddy
        ln -sf ${configFile} %h/.config/moondeckbuddy/config.json
      '';

      serviceConfig = {
        ExecStart = "${lib.getExe prefs.moondeck.package}";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
