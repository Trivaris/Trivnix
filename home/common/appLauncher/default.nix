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
    userPrefs.appLauncher = mkOption {
      type = types.nullOr (types.enum modules);
      default = null;
      example = "rofi";
      description = ''
        Application launcher module to install from `home/common/appLauncher`.
        Leave null to skip adding a dedicated launcher for this profile.
      '';
    };

    vars.appLauncherFlags = mkOption {
      type = types.str;
      default = "";
      description = ''
        Extra flags appended by modules when building keybindings for the launcher.
        This is populated automatically and consumed by Hyprland bindings.
      '';
    };
  };
}
