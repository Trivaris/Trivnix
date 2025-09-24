{
  lib,
  trivnixLib,
  ...
}:
let
  inherit (lib) types mkOption;
  inherit (trivnixLib) resolveDir;

  modules = resolveDir {
    dirPath = ./.;
    preset = "moduleNames";
  };

  imports = resolveDir {
    dirPath = ./.;
    preset = "importList";
  };
in
{
  inherit imports;
  options = {
    userPrefs.desktopEnvironment = mkOption {
      type = types.nullOr (types.enum modules);
      default = null;
      example = "kde";
      description = ''
        Desktop environment module to configure for this user session.
        Map to entries in `home/common/desktopEnvironment` or leave null to skip.
      '';
    };

    vars.desktopEnvironmentBinary = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Launch command exported by the chosen module for display-manager autologin.
        Modules set this automatically so greetd knows which binary to exec.
      '';
    };
  };

}
