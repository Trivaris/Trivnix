config:
let
  prefs = config.userPrefs;
in
{
  bind = {
    windowMove = [
      # Send window in direction
      "$mod, LEFT,  movewindow, l"
      "$mod, RIGHT, movewindow, r"
      "$mod, UP,    movewindow, u"
      "$mod, down,  movewindow, d"

      # Send window to monitor in direction
      "$mod SHIFT, LEFT,  movewindow, mon:l"
      "$mod SHIFT, RIGHT, movewindow, mon:r"
      "$mod SHIFT, UP,    movewindow, mon:u"
      "$mod SHIFT, DOWN,  movewindow, mon:d"

      # Split window horizontally/vertically
      "$alt_mod, H, layoutmsg, preselect d"
      "$alt_mod, V, layoutmsg, preselect r"
      "$alt_mod, Y, togglesplit"
    ];

    mouseFloat = [
      "$mod SHIFT, mouse:272, setfloating, active"
      "$mod SHIFT, mouse:273, setfloating, active"
    ];

    windowFocus = [
      # Focus window in direction
      "$alt_mod, LEFT,  movefocus, l"
      "$alt_mod, RIGHT, movefocus, r"
      "$alt_mod, UP,    movefocus, u"
      "$alt_mod, DOWN,  movefocus, d"

      # Focus window on monitor in direction
      "$alt_mod SHIFT, LEFT,  focusmonitor, l"
      "$alt_mod SHIFT, RIGHT, focusmonitor, r"
      "$alt_mod SHIFT, UP,    focusmonitor, u"
      "$alt_mod SHIFT, DOWN,  focusmonitor, d"
    ];

    programs = [
      "$mod, Q, killactive"

      "$mod, RETURN, exec, ${toString prefs.terminalEmulator}"
      "$mod, SPACE, exec, ${prefs.appLauncher} ${config.vars.appLauncherFlags}"
      "$mod, B, exec, ${builtins.head prefs.browsers}"
      "$mod, S, exec, spotify"
      "$mod, D, exec, vesktop"
      "$mod, C, exec, codium"
      "$mod, T, exec, thunderbird"
      "$mod, E, exec, dolphin" 
    ];

    volume = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.1 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.1 @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ];

    screenshot = [
      ", Print, exec, hyprshot -m region"
    ];
  };

  bindm = {
    windowDrag = [
      "$mod, mouse:272, movewindow"
      "$mod SHIFT, mouse:272, movewindow"
      "$mod SHIFT, mouse:273, resizewindow"
    ];
  };

  bindc = {
    mouseClick = [
      "$mod SHIFT, mouse:272, settiled, active"
    ];
  };
}
