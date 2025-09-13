{ lib, trivnixLib, ... }:
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
      description = "Your Desktop Environment";
    };

    vars.desktopEnvironmentBinary = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Executable binary to launch when autologin is enabled for this desktop environment.";
    };
  };

}
