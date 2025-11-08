{ config, lib }:
let
  inherit (lib) mkIf range;
  prefs = config.userPrefs;
  isEnabled =
    module:
    builtins.elem module (
      prefs.misc.otherPrograms ++ (lib.flatten (builtins.attrValues prefs.misc.otherPackages))
    );
in
{
  bind = {
    windowMove = [
      # Send window in direction
      "$mod, LEFT,  movewindow, l"
      "$mod, RIGHT, movewindow, r"
      "$mod, UP,    movewindow, u"
      "$mod, down,  movewindow, d"

      # Split window horizontally/vertically
      "$alt_mod, Y, togglesplit"
    ];

    workspaceChange = [
      "$mod, TAB, workspace, e+1"
      "$mod SHIFT, TAB, workspace, e-1"
    ]
    ++ map (index: "$mod, ${toString index}, workspace, ${toString index}") (range 0 9);

    mouseFloat = [
      # Make active window floating for mouse drag/resize
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
      "$mod, E, exec, dolphin"
      "$mod, L, exec, hyprlock"

      "$mod, RETURN, exec, ${toString prefs.terminalEmulator}"
      "$mod, SPACE, exec, ${prefs.appLauncher} ${config.vars.appLauncherFlags}"
    ]
    ++ [
      (mkIf prefs.librewolf.enable "$mod, W, exec, librewolf")
      (mkIf (isEnabled "vscode") "$mod, A, exec, code")
      (mkIf (isEnabled "vscodium") "$mod, A, exec, codium")
      (mkIf (isEnabled "spotify" || isEnabled "spicetify") "$mod, S, exec, spotify")
      (mkIf (isEnabled "vesktop") "$mod, D, exec, vesktop")
      (mkIf prefs.thunderbird.enable "$mod, Z, exec, thunderbird")
    ];

    volume = [
      # Control system volume (PipeWire) via wpctl
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.1 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.1 @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ];

    screenshot = [
      # Region screenshot with selection (hyprshot)
      ", Print, exec, hyprshot -m region"
    ];
  };

  bindm = {
    windowDrag = [
      # Drag and resize windows with mouse
      "$mod, mouse:272, movewindow"
      "$mod SHIFT, mouse:272, movewindow"

      # Resize tiled or floating windows by dragging with Mod + Right Click
      "$mod, mouse:273, resizewindow"
      "$mod SHIFT, mouse:273, resizewindow"
    ];
  };

  bindc = {
    mouseClick = [
      # Force tiling on click to escape floating
      "$mod SHIFT, mouse:272, settiled, active"
    ];
  };
}
