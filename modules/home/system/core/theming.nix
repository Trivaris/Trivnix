{
  flake.homeModules.system-core =
    {
      osConfig,
      pkgs,
      ...
    }:
    let
      hostTheming = osConfig.host.theming;
      scheme = hostTheming.scheme;

      paletteStr = builtins.concatStringsSep "," [
        scheme.base05
        scheme.base01
        scheme.base02
        scheme.base03
        scheme.base00
        scheme.base01
        scheme.base05
        scheme.base06
        scheme.base05
        scheme.base00
        scheme.base00
        scheme.base00
        scheme.base0D
        scheme.base00
        scheme.base0D
        scheme.base0E
        scheme.base01
        scheme.base00
        scheme.base01
        scheme.base05
        scheme.base03
      ];

      disabledStr = builtins.concatStringsSep "," [
        scheme.base03
        scheme.base01
        scheme.base02
        scheme.base03
        scheme.base00
        scheme.base01
        scheme.base03
        scheme.base04
        scheme.base03
        scheme.base00
        scheme.base00
        scheme.base00
        scheme.base02
        scheme.base00
        scheme.base03
        scheme.base03
        scheme.base01
        scheme.base00
        scheme.base01
        scheme.base03
        scheme.base03
      ];

      qtTheme = pkgs.writeText "base16-qt6ct.conf" ''
        [ColorScheme]
        active_colors=${paletteStr}
        inactive_colors=${paletteStr}
        disabled_colors=${disabledStr}
      '';
    in
    {
      xdg.configFile."hypr/hyprqt6engine.conf".text = ''
        theme {
          style = Fusion
          color_scheme = ${qtTheme}
          icon_theme = Papirus-Dark
          font = ${osConfig.host.theming.font.propoName}
          font_size = 11
          font_fixed = ${osConfig.host.theming.font.monoName}
          font_fixed_size = 11
        }

        misc {
          single_click_activate = true
          menus_have_icons = true
          shortcuts_for_context_menus = true
        }
      '';

      home = {
        pointerCursor = {
          enable = true;
          gtk.enable = true;
          x11.enable = true;
          hyprcursor.enable = true;
          size = 24;
          name = "BreezeX-RosePine-Linux";
          package = pkgs.rose-pine-cursor;
        };

        sessionVariables = {
          QT_QPA_PLATFORMTHEME = "hyprqt6engine";
          QT_QUICK_CONTROLS_STYLE = "Fusion";
          QT_PLUGIN_PATH = "${pkgs.hyprqt6engine}/${pkgs.qt6.qtbase.qtPluginPrefix}";
        };

        packages = [
          pkgs.hyprqt6engine
        ];
      };

      dconf.settings."org/gnome/desktop/interface".color-scheme =
        if hostTheming.darkMode then "prefer-dark" else "prefer-light";

      gtk = {
        enable = true;

        theme = {
          name = if hostTheming.darkMode then "adw-gtk3-dark" else "adw-gtk3";
          package = pkgs.adw-gtk3;
        };

        iconTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };

        gtk2.enable = false;
        gtk3.extraConfig.gtk-application-prefer-dark-theme = if hostTheming.darkMode then 1 else 0;
        gtk4.extraConfig.gtk-application-prefer-dark-theme = if hostTheming.darkMode then 1 else 0;
      };
    };
}
