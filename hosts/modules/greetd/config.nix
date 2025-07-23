{ pkgs, lib}:
with lib;
{
  enable = mkEnableOption "Enable Greeter";

  command = mkOption {
    type = types.str;
    default = "env XDG_SESSION_TYPE=tty ${pkgs.tmux}/bin/tmux new-session -A -s main ${pkgs.fish}/bin/fish";
    example = "env XDG_SESSION_TYPE=wayland dbus-run-session ${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland";
    description = ''
      Command to run as the session when greeter logs in.
    '';
  };

  pkg = mkOption {
    type = types.enum (builtins.attrNames pkgs.greetd);
    example = "tuigreet";
    description = ''
      The package greetd uses to launch a session.
      Must be the name of a package within `pkgs.greetd`
    '';
  };

  user = mkOption {
    type = types.str;
    default = "greetd";
    description = "User used to run the greetd session.";
  };
}