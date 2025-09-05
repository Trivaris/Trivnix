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
  options.userPrefs.appLauncher = {
    name = mkOption {
      type = types.nullOr (types.enum modules);
      default = null;
      example = "rofi";
      description = "Your App Launcher";
    };

    flags = mkOption {
      type = types.str;
      default = "";
      description = "Flags to use when launching via keybinds. Is set automatically";
    };
  };
}
