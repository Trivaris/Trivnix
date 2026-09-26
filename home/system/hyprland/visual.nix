{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  scheme = osConfig.themingPrefs.scheme;
  toARGB = color: "0xff${lib.removePrefix "#" color}";
  withAlpha = alpha: color: "0x${alpha}${lib.removePrefix "#" color}";
  
  paletteStr = with scheme; builtins.concatStringsSep "," [
    base05 base01 base02 base03 base00 base01 base05
    base06 base05 base00 base00 base00 base0D base00
    base0D base0E base01 base00 base01 base05 base03
  ];

  disabledStr = with scheme; builtins.concatStringsSep "," [
    base03 base01 base02 base03 base00 base01 base03
    base04 base03 base00 base00 base00 base02 base00
    base03 base03 base01 base00 base01 base03 base03
  ];

  qtTheme = pkgs.writeText "base16-qt6ct.conf" ''
    [Appearance]
    custom_palette=true

    [Palette]
    active=${paletteStr}
    inactive=${paletteStr}
    disabled=${disabledStr}
  '';
in
{
  config = lib.mkIf (!osConfig.hostPrefs.headless) {
    home.sessionVariables.QT_QPA_PLATFORMTHEME = lib.mkForce "hyprqt6engine";
    xdg.configFile."hypr/hyprqt6engine.conf".text = ''
      theme {
        style = Fusion
        color_scheme = ${qtTheme}
        icon_theme = Papirus-Dark
        font = ${osConfig.themingPrefs.font.propoName}
        font_size = 11
        font_fixed = ${osConfig.themingPrefs.font.monoName}
        font_fixed_size = 11
      }

      misc {
        single_click_activate = true
        menus_have_icons = true
        shortcuts_for_context_menus = true
      }
    '';

    wayland.windowManager.hyprland.settings = {
      env = [ { _args = [ "QT_QPA_PLATFORMTHEME" "hyprqt6engine"]; } ];
      animation = map lib.generators.mkLuaInline [  
        ''{ leaf = "windows", enabled = true, speed = 4, bezier = "easeOutExpo", style = "slide" }''
        ''{ leaf = "windowsOut", enabled = true, speed = 4, bezier = "easeOutExpo", style = "slide" }''
        ''{ leaf = "windowsMove", enabled = true, speed = 4, bezier = "easeOutExpo" }''
        ''{ leaf = "border", enabled = true, speed = 5, bezier = "easeOutCirc" }''
        ''{ leaf = "fade", enabled = true, speed = 3, bezier = "easeOutCirc" }''
        ''{ leaf = "workspaces", enabled = true, speed = 4, bezier = "easeOutExpo", style = "slide" }''
      ];

      curve = [
        { _args = [ "easeOutExpo"  { type = "bezier"; points = [ [0.16 1] [0.3 1] ]; } ]; }
        { _args = [ "easeOutCirc" { type = "bezier"; points = [ [0.075 0.82] [0.165 1] ]; } ]; }
      ];

      window_rule = map lib.generators.mkLuaInline [
        ''{ match = { title = "Open Folder" }, float = true, size = "window_w window_h", center = true }''
        ''{ match = { title = "Open File" }, float = true, size = "window_w window_h", center = true }''
        ''{ match = { class = "waypaper" }, float = true, size = "window_w window_h", center = true }''
        ''{ match = { class = "io.github.kaii_lb.Overskride" }, float = true, size = "window_w window_h", center = true }''
        ''{ match = { class = "nm-connection-editor" }, float = true, size = "window_w window_h", center = true }''
        ''{ match = { class = "com.network.manager" }, float = true, size = "window_w window_h", center = true }''
        ''{ match = { class = ".blueman-manager-wrapped" }, float = true, size = "window_w window_h", center = true }''
        ''{ match = { class = "com.saivert.pwvucontrol" }, float = true, size = "window_w window_h", center = true }''
        ''{ match = { class = "org.kde.dolphin" }, float = true, size = "window_w window_h", center = true }''
        ''{ match = { class = "org.gnome.Nautilus" }, float = true, size = "window_w*1.5 window_h*1.5", center = true }''
        ''{ match = { class = "org-jdownloader-update-launcher-JDLauncher" }, float = true, size = "window_w*1.5 window_h*1.5", center = true }''
        ''{ match = { class = "thunderbird", title = "^Write:.*" }, float = true, size = "window_w window_h", center = true }''
        ''{ match = { class = "steam", title = "^Steam Settings$" }, float = true, size = "window_w window_h", center = true }''
        ''{ match = { class = "librewolf", title = "^Extension: \\(Bitwarden Password Manager\\) - Bitwarden — LibreWolf$" }, float = true, size = "window_w window_h", center = true }''
        ''{ match = { title = "^LiveSplit$" }, float = true, size = "250 400", center = true }''
        ''{ match = { class = "^(steam_app_.*)$" }, opaque = true }''
        ''{ match = { class = "^(steam_app_.*)$" }, idle_inhibit = "always" }''
      ];

      config = {
        master.new_status = "master";
        animations.enabled = true;

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          layout = "dwindle";
          resize_on_border = true;
          extend_border_grab_area = 15;
          hover_icon_on_border = true;
          "col.active_border" =         { colors = [ (toARGB scheme.base05) (toARGB scheme.base0D) ];  angle = 180; };
          "col.inactive_border" =       { colors = [ (toARGB scheme.base03) (toARGB scheme.base01) ];  angle = 180; };
          "col.nogroup_border" =        { colors = [ (toARGB scheme.base03) (toARGB scheme.base01) ];  angle = 180; };
          "col.nogroup_border_active" = { colors = [ (toARGB scheme.base05) (toARGB scheme.base0A) ];  angle = 180; };
        };

        decoration = {
          rounding = 4;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
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
            color = withAlpha "aa" (scheme.base00);
          };
        };

        dwindle = {
          preserve_split = true;
          smart_split = true;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          mouse_move_enables_dpms = true;
          vrr = 1;
        };

        render = {
          direct_scanout = 2;
          new_render_scheduling = true;
        };

        group = {
          "col.border_active" = toARGB scheme.base0D;
          "col.border_inactive" = toARGB scheme.base03;

          groupbar = {
            enabled = true;
            text_color = toARGB scheme.base05;
            "col.active" = toARGB scheme.base0D;
            "col.inactive" = toARGB scheme.base02;
          };
        };
      };
    };
  };
}
