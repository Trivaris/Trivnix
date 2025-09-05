lib:
let
  inherit (lib) mkOption types;
in
{
  monitor = mkOption {
    type = types.listOf types.str;
    default = [ ];
    example = [ "HDMI-A-1, 1920x1080@60, 0x840, 1" ];
    description = "Hyprland Monitor Configuration. See `https://wiki.hypr.land/Configuring/Monitors/`";
  };
}
