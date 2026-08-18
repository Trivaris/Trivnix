{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  main_mod = "SUPER";
  alt_mod = "ALT";

  workspaceDispatch = pkgs.writeShellScriptBin "hypr-ws" ''
    cmd=$1
    base=$2

    focused_mon=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name')

    offset=0
    case "$focused_mon" in
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: m: ''
          "${name}") offset=$(( ${toString m.workspaceIndex} * 10 ));;
        '') osConfig.hostInfos.monitors
      )}
    esac

    target=$((base + offset))

    if [ "$cmd" = "workspace" ]; then
      ${pkgs.hyprland}/bin/hyprctl dispatch "hl.dsp.focus({ workspace = $target })"
    elif [ "$cmd" = "movetoworkspace" ]; then
      ${pkgs.hyprland}/bin/hyprctl dispatch "hl.dsp.window.move({ workspace = $target })"
    fi
  '';
in
{
  config = lib.mkIf (!osConfig.hostPrefs.headless) {
    wayland.windowManager.hyprland.settings = {
  
    config.binds.drag_threshold = 10;
    bind = [
      # windowMove
      { _args = [ "${main_mod} + LEFT"  (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "l" })'') ]; }
      { _args = [ "${main_mod} + RIGHT" (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "r" })'') ]; }
      { _args = [ "${main_mod} + UP"    (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "u" })'') ]; }
      { _args = [ "${main_mod} + DOWN"  (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "d" })'') ]; }
      { _args = [ "${alt_mod}  + Y"     (lib.generators.mkLuaInline ''hl.dsp.layout("togglesplit")'') ]; }
      { _args = [ "F11"                 (lib.generators.mkLuaInline ''hl.dsp.window.fullscreen()'') ]; }
    
      # workspaceChange
      { _args = [ "${main_mod} + TAB"         (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "e+1" })'') ]; }
      { _args = [ "${main_mod} + SHIFT + TAB" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "e-1" })'') ]; }
    
      # windowFocus
      { _args = [ "${alt_mod} + SHIFT + LEFT"  (lib.generators.mkLuaInline ''hl.dsp.focus({ monitor = "l" })'') ]; }
      { _args = [ "${alt_mod} + SHIFT + RIGHT" (lib.generators.mkLuaInline ''hl.dsp.focus({ monitor = "r" })'') ]; }
      { _args = [ "${alt_mod} + SHIFT + UP"    (lib.generators.mkLuaInline ''hl.dsp.focus({ monitor = "u" })'') ]; }
      { _args = [ "${alt_mod} + SHIFT + DOWN"  (lib.generators.mkLuaInline ''hl.dsp.focus({ monitor = "d" })'') ]; }
      { _args = [ "${alt_mod} + LEFT"  (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "l" })'') ]; }
      { _args = [ "${alt_mod} + RIGHT" (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "r" })'') ]; }
      { _args = [ "${alt_mod} + DOWN"  (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "d" })'') ]; }
      { _args = [ "${alt_mod} + UP"    (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "u" })'') ]; }
    
      # programs
      { _args = [ "${main_mod} + E"      (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("nautilus")'') ]; }
      { _args = [ "${main_mod} + L"      (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("hyprlock")'') ]; }
      { _args = [ "${main_mod} + A"      (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("code")'') ]; }
      { _args = [ "${main_mod} + D"      (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("vesktop")'') ]; }
      { _args = [ "${main_mod} + W"      (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("librewolf")'') ]; }
      { _args = [ "${main_mod} + S"      (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("spotify")'') ]; }
      { _args = [ "${main_mod} + Z"      (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("thunderbird")'') ]; }
      { _args = [ "${main_mod} + Q"      (lib.generators.mkLuaInline "hl.dsp.window.close()") ]; }
      { _args = [ "${main_mod} + SPACE"  (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${config.vars.terminalEmulator}")'') ]; }
      { _args = [ "${main_mod} + RETURN" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${config.vars.appLauncher} ${config.vars.appLauncherFlags}")'') ]; }
    
      # volume
      { _args = [ "XF86AudioRaiseVolume" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wpctl set-volume -l 1.1 @DEFAULT_AUDIO_SINK@ 5%+")'') ]; }
      { _args = [ "XF86AudioLowerVolume" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wpctl set-volume -l 1.1 @DEFAULT_AUDIO_SINK@ 5%-")'') ]; }
      { _args = [ "XF86AudioMute"        (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")'') ]; }
    
      # backlight
      { _args = [ "XF86MonBrightnessUp"   (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("brightnessctl s +5%")'') ]; }
      { _args = [ "XF86MonBrightnessDown" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("brightnessctl s 5%-")'') ]; }
    
      # screenshot
      { _args = [ "Print" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("HYPRSHOT_DIR=~/Pictures/Screenshots/ hyprshot -m region")'') ]; }
    
      # specialChars
      { _args = [ "${alt_mod} + O"         (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wtype ö")'') ]; }
      { _args = [ "${alt_mod} + SHIFT + O" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wtype Ö")'') ]; }
      { _args = [ "${alt_mod} + A"         (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wtype ä")'') ]; }
      { _args = [ "${alt_mod} + SHIFT + A" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wtype Ä")'') ]; }
      { _args = [ "${alt_mod} + U"         (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wtype ü")'') ]; }
      { _args = [ "${alt_mod} + SHIFT + U" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wtype Ü")'') ]; }
      { _args = [ "${alt_mod} + S"         (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wtype ß")'') ]; }
    
      # mouseAction
      { _args = [ "${main_mod} + mouse:272"         (lib.generators.mkLuaInline "hl.dsp.window.drag()") ]; }
      { _args = [ "${main_mod} + mouse:273"         (lib.generators.mkLuaInline "hl.dsp.window.resize()") ]; }
      { _args = [ "${main_mod} + SHIFT + mouse:273" (lib.generators.mkLuaInline "hl.dsp.window.resize()") ]; }
      
      { _args = [ "${main_mod} + SHIFT + mouse:272" (lib.generators.mkLuaInline ''hl.dsp.window.float({ action = "set" })'') ]; }
      { _args = [ "${main_mod} + SHIFT + mouse:273" (lib.generators.mkLuaInline ''hl.dsp.window.float({ action = "set" })'') ]; }

    ]
      # More Workspace Change
      ++ (map (
        index: { _args = [ "${main_mod} + ${toString index}" (lib.generators.mkLuaInline ''hl.dsp.exec_raw("${workspaceDispatch}/bin/hypr-ws workspace ${toString index}")'') ]; }
      ) (lib.range 0 9))
      ++ (map (
        index: { _args = [ "${main_mod} + SHIFT + ${toString index}" (lib.generators.mkLuaInline ''hl.dsp.exec_raw("${workspaceDispatch}/bin/hypr-ws movetoworkspace ${toString index}")'') ]; }
      ) (lib.range 0 9));
    };
  };
}