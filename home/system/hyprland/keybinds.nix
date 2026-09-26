{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  mkLua = lib.generators.mkLuaInline;
  term = config.vars.terminalEmulator;
  main_mod = "SUPER";
  alt_mod = "ALT";
  wsKeys = [ "U" "I" "O" "P" "bracketleft" ];

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
      ${lib.getExe' pkgs.hyprland "hyprctl"} dispatch "hl.dsp.focus({ workspace = $target })"
    elif [ "$cmd" = "movetoworkspace" ]; then
      ${lib.getExe' pkgs.hyprland "hyprctl"} dispatch "hl.dsp.window.move({ workspace = $target })"
    fi
  '';

in
{
  config = lib.mkIf (!osConfig.hostPrefs.headless) {
    wayland.windowManager.hyprland.settings = {
      config.binds.drag_threshold = 10; 
      config.input = {
        kb_layout = "eu";
        kb_options = "caps:super,lv3:switch";
      };

      bind = [
        # windowMove
        { _args = [ "${main_mod} + ${alt_mod} + H"      (mkLua ''hl.dsp.window.move({ direction = "l" })'') ]; }
        { _args = [ "${main_mod} + ${alt_mod} + J"      (mkLua ''hl.dsp.window.move({ direction = "d" })'') ]; }
        { _args = [ "${main_mod} + ${alt_mod} + K"      (mkLua ''hl.dsp.window.move({ direction = "u" })'') ]; }
        { _args = [ "${main_mod} + ${alt_mod} + L"      (mkLua ''hl.dsp.window.move({ direction = "r" })'') ]; }
        { _args = [ "${alt_mod}  + Y"                   (mkLua ''hl.dsp.layout("togglesplit")'') ]; }
        { _args = [ "F11"                               (mkLua ''hl.dsp.window.fullscreen()'') ]; }
      
        # workspaceChange
        { _args = [ "${main_mod} + TAB"                 (mkLua ''hl.dsp.focus({ workspace = "e+1" })'') ]; }
        { _args = [ "${main_mod} + SHIFT + TAB"         (mkLua ''hl.dsp.focus({ workspace = "e-1" })'') ]; }
      
        # windowFocus
        { _args = [ "${main_mod} + H"                   (mkLua ''hl.dsp.focus({ direction = "l" })'') ]; }
        { _args = [ "${main_mod} + J"                   (mkLua ''hl.dsp.focus({ direction = "d" })'') ]; }
        { _args = [ "${main_mod} + K"                   (mkLua ''hl.dsp.focus({ direction = "u" })'') ]; }
        { _args = [ "${main_mod} + L"                   (mkLua ''hl.dsp.focus({ direction = "r" })'') ]; }
      
        # programs
        { _args = [ "${main_mod} + Q"                   (mkLua ''hl.dsp.window.close()'') ]; }
        { _args = [ "${main_mod} + RETURN"              (mkLua ''hl.dsp.exec_cmd("${term}")'') ]; }
        { _args = [ "${main_mod} + ${alt_mod} + M"      (mkLua ''hl.dsp.exec_cmd("${lib.getExe pkgs.rofi} -show drun")'') ]; }
        { _args = [ "${main_mod} + ${alt_mod} + F"      (mkLua ''hl.dsp.exec_cmd("${lib.getExe pkgs.rofi-rbw-wayland}")'') ]; }
        { _args = [ "${main_mod} + ${alt_mod} + E"      (mkLua ''hl.dsp.exec_cmd("nautilus")'') ]; }
        { _args = [ "${main_mod} + ${alt_mod} + C"      (mkLua ''hl.dsp.exec_cmd("hyprlock")'') ]; }
        { _args = [ "${main_mod} + ${alt_mod} + A"      (mkLua ''hl.dsp.exec_cmd("code")'') ]; }
        { _args = [ "${main_mod} + ${alt_mod} + D"      (mkLua ''hl.dsp.exec_cmd("vesktop")'') ]; }
        { _args = [ "${main_mod} + ${alt_mod} + S"      (mkLua ''hl.dsp.exec_cmd("feishin")'') ]; }
        { _args = [ "${main_mod} + ${alt_mod} + Z"      (mkLua ''hl.dsp.exec_cmd("thunderbird")'') ]; }
        { _args = [ "${main_mod} + ${alt_mod} + W"      (mkLua ''hl.dsp.exec_cmd("librewolf")'') ]; }
        
        { _args = [ "${main_mod} + ${alt_mod} + RETURN" (mkLua ''hl.dsp.focus({ window = "class:${term}"     })'') ]; }
        { _args = [ "${main_mod} + A"                   (mkLua ''hl.dsp.focus({ window = "class:code"        })'') ]; }
        { _args = [ "${main_mod} + D"                   (mkLua ''hl.dsp.focus({ window = "class:vesktop"     })'') ]; }
        { _args = [ "${main_mod} + S"                   (mkLua ''hl.dsp.focus({ window = "class:feishin"     })'') ]; }
        { _args = [ "${main_mod} + Z"                   (mkLua ''hl.dsp.focus({ window = "class:thunderbird" })'') ]; }
        { _args = [ "${main_mod} + W"                   (mkLua ''hl.dsp.focus({ window = "class:librewolf"   })'') ]; }
      
        # screenshot
        { _args = [ "Print"                             (mkLua ''hl.dsp.exec_cmd("HYPRSHOT_DIR=~/Pictures/Screenshots/ hyprshot -m region")'') ]; }

        # volume
        { _args = [ "XF86AudioRaiseVolume"              (mkLua ''hl.dsp.exec_cmd("wpctl set-volume -l 1.1 @DEFAULT_AUDIO_SINK@ 5%+")'') ]; }
        { _args = [ "XF86AudioLowerVolume"              (mkLua ''hl.dsp.exec_cmd("wpctl set-volume -l 1.1 @DEFAULT_AUDIO_SINK@ 5%-")'') ]; }
        { _args = [ "XF86AudioMute"                     (mkLua ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")'') ]; }
      
        # backlight
        { _args = [ "XF86MonBrightnessUp"               (mkLua ''hl.dsp.exec_cmd("brightnessctl s +5%")'') ]; }
        { _args = [ "XF86MonBrightnessDown"             (mkLua ''hl.dsp.exec_cmd("brightnessctl s 5%-")'') ]; }

        # mouseAction
        { _args = [ "${main_mod} + mouse:272"           (mkLua ''hl.dsp.window.drag()'') ]; }
        { _args = [ "${main_mod} + mouse:273"           (mkLua ''hl.dsp.window.resize()'') ]; }
        { _args = [ "${main_mod} + SHIFT + mouse:273"   (mkLua ''hl.dsp.window.resize()'') ]; }
        
        { _args = [ "${main_mod} + SHIFT + mouse:272"   (mkLua ''hl.dsp.window.float({ action = "set" })'') ]; }
        { _args = [ "${main_mod} + SHIFT + mouse:273"   (mkLua ''hl.dsp.window.float({ action = "set" })'') ]; }

      ]
      # More Workspace Change
      ++ (map (
        index: { _args = [ "${main_mod} + ${builtins.elemAt wsKeys (index - 1)}"              (mkLua ''hl.dsp.exec_raw("${workspaceDispatch}/bin/hypr-ws workspace ${toString index}")'') ]; }
      ) (lib.range 1 5))
      ++ (map (
        index: { _args = [ "${main_mod} + ${toString index}"                                  (mkLua ''hl.dsp.exec_raw("${workspaceDispatch}/bin/hypr-ws workspace ${toString index}")'') ]; }
      ) (lib.range 1 5))
      ++ (map (
        index: { _args = [ "${main_mod} + ${alt_mod} + ${builtins.elemAt wsKeys (index - 1)}" (mkLua ''hl.dsp.exec_raw("${workspaceDispatch}/bin/hypr-ws movetoworkspace ${toString index}")'') ]; }
      ) (lib.range 1 5))
      ++ (map (
        index: { _args = [ "${main_mod} + ${alt_mod} + ${toString index}" (mkLua ''hl.dsp.exec_raw("${workspaceDispatch}/bin/hypr-ws movetoworkspace ${toString index}")'') ]; }
      ) (lib.range 1 5));
    };
  };
}