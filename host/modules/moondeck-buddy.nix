{
  config,
  lib,
  pkgs,
  ...
}:
let
  moondeckPrefs = config.hostPrefs;
  jsonFormat = pkgs.formats.json { };
  configFile = jsonFormat.generate "moondeckbuddy-config.json" (
    moondeckPrefs.settings
    // {
      port = moondeckPrefs.port;
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

  config = lib.mkIf moondeckPrefs.enable {
    environment.systemPackages = [ moondeckPrefs.package ];

    networking.firewall = lib.mkIf moondeckPrefs.openFirewall {
      allowedTCPPorts = [
        moondeckPrefs.port
        moondeckPrefs.infoPort
      ];
      allowedUDPPorts = [
        47999
        moondeckPrefs.port
        moondeckPrefs.infoPort
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

      path = [
        pkgs.steam
        pkgs.steam-run
        pkgs.which
        pkgs.bash
      ];

      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.moondeck-buddy}";
        Environment = "QT_STYLE_OVERRIDE=Fusion";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
