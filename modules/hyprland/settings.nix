{ lib, config, ... }:
let
  mkRgb = c: "rgb(${lib.removePrefix "#" c})";
  terminal = "wezterm";
  launcher = "rofi";
in
with lib;
{

  imports = [
    ./autostart.nix
    ./bindings.nix
  ];

  config = mkIf config.modules.hyprland {
    wayland.windowManager.hyprland.settings =
      let
        colors = config.colors;
      in 
      lib.mkMerge [
      {

        general = {
          "$terminal" = terminal;
          "$launcher" = launcher;

          border_size = 0;
          no_border_on_floating = true;

          gaps_in = 8;
          gaps_out = 8;
          float_gaps = 8;
          
          "col.active_border" = "${mkRgb colors.fg} ${mkRgb colors.bg5} 45deg";
          "col.inactive_border" = "${mkRgb colors.bg_dim} ${mkRgb colors.bg0} 45deg";

          layout = "dwindle";
        };

        misc = {
          disable_autoreload = true;
          disable_hyprland_logo = true;
          always_follow_on_dnd = true;
          layers_hog_keyboard_focus = true;
          animate_manual_resizes = false;
          enable_swallow = true;
          focus_on_activate = true;
          new_window_takes_over_fullscreen = 2;
          middle_click_paste = false;
        };

        monitor = [ ",preferred,auto,auto" ];

      }
    ];
  };

}
