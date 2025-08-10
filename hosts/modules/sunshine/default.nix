{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.nixosConfig;
in
{
  options.nixosConfig.sunshine = import ./config.nix { inherit (lib) mkEnableOption mkOption types; };

  config = mkIf cfg.sunshine.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;

      settings = {
        port = mkIf (cfg.sunshine.port != null) cfg.sunshine.port;
        gamepad = "x360";
        # motion_as_ds4 = "disabled";
        # touchpad_as_ds4 = "disabled";
        # upnp = "enabled";
        capture = "kms";
        output_name = 2;
        external_ip = cfg.sunshine.domain;
        origin_web_ui_allowed = "wan";
        wan_encryption_mode = 0;
      };

      applications = {
        env = {
          WAYLAND_DISPLAY = "wayland-0";
          XDG_RUNTIME_DIR = "/run/user/1000";
          DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
          PATH = "$(PATH):$HOME/.local/bin";
        };

        apps = [
          {
            name = "AFK Journey";
            cmd = [
              "/run/current-system/sw/bin/setsid"
              "/run/current-system/sw/bin/lutris"
              "lutris:rungameid/2"
            ];
            image-path = "afk-journey.png";
            auto-detach = true;
            elevated = false;
            exclude-global-prep-cmd = false;
            exit-timeout = 5;
            output = "";
            wait-all = true;
          }
          {
            name = "Desktop";
            image-path = "desktop.png";
          }
          {
            name = "Steam Big Picture";
            image-path = "steam.png";
            detached = [ "setsid steam steam://open/bigpicture" ];
            prep-cmd = [
              {
                do = "";
                undo = "setsid steam steam://close/bigpicture";
              }
            ];
          }
        ];
      };
    };
  };
}
