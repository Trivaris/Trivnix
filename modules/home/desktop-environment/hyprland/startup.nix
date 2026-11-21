{
  flake.homeModules.desktop-environment-hyprland = { pkgs, lib, config, ... }:
  let
    cfg = config.user.preferences.hyprland;

    setWallpaper = pkgs.writeShellScript "awww-set-wallpaper" ''
      export PATH=${lib.makeBinPath [ pkgs.awww pkgs.coreutils pkgs.findutils ]}:$PATH
      dir=${lib.escapeShellArg cfg.wallpaperDir}

      # wait for awww-daemon to accept commands (max ~10s)
      for _ in $(seq 100); do
        awww query >/dev/null 2>&1 && break
        sleep 0.1
      done

      img=$(find -L "$dir" -type f \( -iname '*.jpg' -o -iname '*.jpeg' \
        -o -iname '*.png' -o -iname '*.gif' -o -iname '*.webp' \) | shuf -n1)

      if [ -z "$img" ]; then
        echo "No wallpapers found in $dir" >&2
        exit 1
      fi

      exec awww img "$img"
    '';
  in
  {
    options.user.preferences.hyprland.wallpaperDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Pictures/Wallpapers";
      description = "Directory to pick a random wallpaper from.";
    };

    config.systemd.user.services = {
      awww-daemon = {
        Unit = {
          Description = "awww wallpaper daemon";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = lib.getExe' pkgs.awww "awww-daemon";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      awww-wallpaper = {
        Unit = {
          Description = "Set random wallpaper";
          After = [ "awww-daemon.service" "awww-daemon.service" ];
          Requires = [ "awww-daemon.service" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = setWallpaper;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
