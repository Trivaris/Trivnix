{
  lib,
  osConfig,
  ...
}:
{
  config =
    let
      theme = osConfig.themingPrefs.scheme;
      toARGB = color: "0xff${lib.removePrefix "#" color}";
      withAlpha = alpha: color: "0x${alpha}${lib.removePrefix "#" color}";
    in
    lib.mkIf (!osConfig.hostPrefs.headless) {
      wayland.windowManager.hyprland.settings = {
        master.new_status = "master";

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          layout = "dwindle";
          resize_on_border = true;
          extend_border_grab_area = 15;
          hover_icon_on_border = true;
          "col.active_border" = "${toARGB theme.base0D} ${toARGB theme.base0E} 45deg";
          "col.inactive_border" = toARGB theme.base03;
          "col.nogroup_border" = toARGB theme.base02;
          "col.nogroup_border_active" = toARGB theme.base0A;
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
            color = withAlpha "aa" (theme.base00);
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
          "col.border_active" = toARGB theme.base0D;
          "col.border_inactive" = toARGB theme.base03;

          groupbar = {
            enabled = true;
            text_color = toARGB theme.base05;
            "col.active" = toARGB theme.base0D;
            "col.inactive" = toARGB theme.base02;
          };
        };

        windowrule = [
          "match:class nm-connection-editor, float true, size window_w window_h, center true"
          "match:class com.network.manager, float true, size window_w window_h, center true"
          "match:class .blueman-manager-wrapped, float true, size window_w window_h, center true"
          "match:class com.saivert.pwvucontrol, float true, size window_w window_h, center true"
          "match:class org.kde.dolphin, float true, size window_w window_h, center true"
        ];
      };
    };
}
