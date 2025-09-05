{
  layerrule = [ "blur, logout_dialog" ];
  master.new_status = "master";
  
  general = {
    gaps_in = 5;
    gaps_out = 10;
    border_size = 2;
    layout = "dwindle";
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
      offset = "0, 0";
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
}
