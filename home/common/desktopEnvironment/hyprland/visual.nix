{
  config,
  isNixos,
  lib,
  osConfig,
  trivnixLib,
  ...
}:
let
  inherit (lib) mkIf removePrefix;
  prefs = config.userPrefs;
in
{
  config =
    let
      scheme = (if isNixos then osConfig else config).stylix.base16Scheme;
      getColor = trivnixLib.getColor scheme;
      toARGB = color: "0xff${removePrefix "#" color}";
      withAlpha = alpha: color: "0x${alpha}${removePrefix "#" color}";
    in
    mkIf (prefs.desktopEnvironment == "hyprland") {
      wayland.windowManager.hyprland.settings = {
        layerrule = [ "blur, logout_dialog" ];
        master.new_status = "master";

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          layout = "dwindle";
          resize_on_border = true;
          extend_border_grab_area = 15;
          hover_icon_on_border = true;
          "col.active_border" = "${toARGB (getColor "base0D")} ${toARGB (getColor "base0E")} 45deg";
          "col.inactive_border" = toARGB (getColor "base03");
          "col.nogroup_border" = toARGB (getColor "base02");
          "col.nogroup_border_active" = toARGB (getColor "base0A");
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
            color = withAlpha "aa" (getColor "base00");
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
          "col.border_active" = toARGB (getColor "base0D");
          "col.border_inactive" = toARGB (getColor "base03");

          groupbar = {
            enabled = true;
            text_color = toARGB (getColor "base05");
            "col.active" = toARGB (getColor "base0D");
            "col.inactive" = toARGB (getColor "base02");
          };
        };

        windowrulev2 = [
          "float, class:^(?i)(com\\.saivert\\.)?pwvucontrol$"
          "center, class:^(?i)(com\\.saivert\\.)?pwvucontrol$"
          "float, class:^(?i)nm-connection-(editor|manager)$"
          "center, class:^(?i)nm-connection-(editor|manager)$"
        ];
      };
    };
}
