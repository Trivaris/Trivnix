{ lib, trivnixLib, ... }:
let
  modules = trivnixLib.getModules ./.;
in
{
  options = {
    userPrefs.desktopEnvironment = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum modules);
      default = null;
      example = "hyprland";
      description = ''
        Desktop environment module to configure for this user session.
        Map to entries in `home/common/desktopEnvironment` or leave null to skip.
      '';
    };

    vars.desktopEnvironmentBinary = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Launch command exported by the chosen module for display-manager autologin.
        Modules set this automatically so greetd knows which binary to exec.
      '';
    };
  };

}
