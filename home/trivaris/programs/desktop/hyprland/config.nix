{
  lib,
  config,
  ...
}: let
  mainMod = "SUPER";
  terminal = "wezterm";
  launcher = "rofi";

  mkRgb = c: "rgb(${lib.removePrefix "#" c})";
in {

  imports = [
    ./visual.nix
    ./bindings.nix
    ./autostart.nix
    ./windowrule.nix
  ];

  wayland.windowManager.hyprland.settings = lib.mkMerge [{

    general = {
      "$mainMod" = mainMod;
      "$terminal" = terminal;
      "$launcher" = launcher;
      layout = "dwindle";
      gaps_in = 6;
      gaps_out = 12;
      border_size = 2;
      "col.active_border" = "${mkRgb config.colors.dark.primary_container} ${mkRgb config.colors.dark.tertiary_fixed} 45deg";
      "col.inactive_border" = "0x00000000";
      # border_part_of_window = false;
      no_border_on_floating = false;
    };

    input = {
      kb_layout = "us,de";
      kb_options = "grp:alt_caps_toggle";
      numlock_by_default = true;
      repeat_delay = 300;
      follow_mouse = 0;
      float_switch_override_focus = 0;
      mouse_refocus = 0;
      sensitivity = 0;
      touchpad = {
        natural_scroll = true;
      };
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

    xwayland = { force_zero_scaling = true; };
    monitor = [ ",preferred,auto,auto" ];

  }];
  
}