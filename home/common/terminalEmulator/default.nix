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
  config.wayland.windowManager.hyprland.settings.bind = mkIf (hostPrefs ? desktopEnvironment && hostPrefs.desktopEnvironment == "hyprland") [ "$mod, RETURN, exec, ${toString prefs.terminalEmulator}" ];

  options.userPrefs.terminalEmulator = mkOption {
    type = types.nullOr (types.enum modules);
    default = null;
    example = "alacritty";
    description = "Your Terminal Emulator";
  };
}
