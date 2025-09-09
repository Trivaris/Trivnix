{
  lib,
  getColor,
# config,
}:
let
  # prefs = config.userPrefs;
  clean = string: builtins.replaceStrings [ "\r\n" "\n" "\r" " " ] [ "" "" "" "" ] string;
  get = name: clean (getColor name);
  toARGB = color: "0xff${lib.removePrefix "#" color}";
  withAlpha = alpha: color: "0x${alpha}${lib.removePrefix "#" color}";
in
{
  layerrule = [ "blur, logout_dialog" ];
  master.new_status = "master";

  general = {
    gaps_in = 5;
    gaps_out = 10;
    border_size = 2;
    layout = "dwindle";
    "col.active_border" = "${toARGB (get "base0D")} ${toARGB (get "base0E")} 45deg";
    "col.inactive_border" = toARGB (get "base03");
    "col.nogroup_border" = toARGB (get "base02");
    "col.nogroup_border_active" = toARGB (get "base0A");
  };

  decoration = {
    rounding = 10;
    active_opacity = 0.95;
    inactive_opacity = 0.90;
    fullscreen_opacity = 1.0;

    blur = {
      size = 8;
      passes = 2;
    };

    shadow = {
      enabled = true;
      range = 15;
      render_power = 3;
      offset = "0 0";
      color = withAlpha "aa" (get "base00");
    };
  };

  animations = {
    enabled = true;
    bezier = [ "myBezier, 0.05, 0.9, 0.1, 1.05" ];

    animation = [
      "windows, 1, 2, myBezier"
      "windowsOut, 1, 2, default, popin 80%"
      "border, 1, 3, default"
      "fade, 1, 2, default"
      "fadeSwitch, 1, 2, default"
      "workspaces, 1, 1, default"
    ];
  };

  dwindle = {
    pseudotile = true;
    preserve_split = true;
    smart_split = true;
  };

  misc = {
    disable_hyprland_logo = true;
    disable_splash_rendering = true;
  };

  group = {
    "col.border_active" = toARGB (get "base0D");
    "col.border_inactive" = toARGB (get "base03");

    groupbar = {
      enabled = true;
      text_color = toARGB (get "base05");
      "col.active" = toARGB (get "base0D");
      "col.inactive" = toARGB (get "base02");
    };
  };

  # TODO: Expand on later 
  windowrulev2 = [
    # "opacity 0.95, class:^(?i)alacritty$"
    # "rounding 6, class:^(?i)alacritty$"
    # "bordercolor, ${toARGB (get "base0A")} ${toARGB (get "base0B")}, class:^(?i)alacritty$"
  ];
}
