{
  flake.homeModules.system-core =
    {
      osConfig,
      pkgs,
      ...
    }:
    let
      theme-prefs = osConfig.theme-prefs;
    in
    {
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

        packages = [
          pkgs.gsettings-desktop-schemas
          pkgs.adwaita-icon-theme
          pkgs.gnome-themes-extra
        ];
      };

      dconf.settings."org/gnome/desktop/interface".color-scheme =
        if theme-prefs.darkmode then "prefer-dark" else "prefer-light";

      gtk = {
        enable = true;
        theme = {
          name = "Adwaita";
          package = pkgs.gnome-themes-extra;
        };
        iconTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };
        gtk2.enable = false;
        gtk3.extraConfig.gtk-application-prefer-dark-theme = if theme-prefs.darkmode then 1 else 0;
        gtk4.extraConfig.gtk-application-prefer-dark-theme = if theme-prefs.darkmode then 1 else 0;
      };
    };
}
