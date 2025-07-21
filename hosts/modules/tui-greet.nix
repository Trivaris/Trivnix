{ config, lib, pkgs, ... }:
let
  cfg = config.nixosConfig.tuigreet;
in
with lib;
{
  options.nixosConfig.tuigreet = {
    enable = mkEnableOption "Enable TUI Greeter";

    command = mkOption {
      type = types.str;
      default = "env XDG_SESSION_TYPE=tty ${pkgs.tmux}/bin/tmux new-session -A -s main ${pkgs.fish}/bin/fish";
      example = "env XDG_SESSION_TYPE=wayland dbus-run-session ${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland";
      description = ''
        Command to run as the session when tuigreet logs in.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "greetd";
      description = "User used to run the greetd session.";
    };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd '${cfg.command}'";
          user = cfg.user;
        };
      };
    };

    users.users.${cfg.user} = {
      isSystemUser = true;
      createHome = true;
      home = "/var/lib/${cfg.user}";
      shell = pkgs.bashInteractive;
      group = cfg.user;
    };

    users.groups.${cfg.user} = {};
  };
}
