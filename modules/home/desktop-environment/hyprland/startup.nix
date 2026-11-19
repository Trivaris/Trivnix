{
  flake.homeModules.desktop-environment-hyprland = {pkgs, lib, config, ... }:
  let
    hyprlandPreferences = config.user.preferences.hyprland;
    script = pkgs.writeShellScript "hyprland-startup" ''
      export PATH=${lib.makeBinPath hyprlandPreferences.startupPackages}:$PATH
      ${hyprlandPreferences.startup}
      qs ipc call lock lock
    '';
  in
  {
    options.user.preferences.hyprland = {
      startup = lib.mkOption {
        type = lib.types.lines;
        default = "waypaper --random --folder ~/Pictures/Wallpapers";
        description = "Commands to run at startup";
      };
      startupPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ pkgs.waypaper pkgs.awww pkgs.quickshell ];
        description = "Packages made available on PATH for the startup script.";
      };
    };
    config.systemd.user.services.hyprland-startup = {
      Unit = {
        Description = "Hyprland Startup";
        After = [
          "graphical-session.target"
          "quickshell.service"
        ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${script}";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}