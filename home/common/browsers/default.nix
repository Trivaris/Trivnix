{ lib, trivnixLib, config, hostPrefs, ... }:
let
  inherit (lib) types mkOption mkIf;
  inherit (trivnixLib) resolveDir;
  prefs = config.userPrefs;

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
  config.wayland.windowManager.hyprland.settings.bind = mkIf (hostPrefs ? desktopEnvironment && hostPrefs.desktopEnvironment == "hyprland" && prefs.browsers != []) [ "$mod, B,  exec, ${builtins.head prefs.browsers}" ];
  
  options.userPrefs.browsers = mkOption {
    type = types.listOf (types.enum modules);
    default = [ ];
    example = [ "chromium" ];
    description = "Your Browsers";
  };
}
