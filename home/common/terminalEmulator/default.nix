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
  options.userPrefs.terminalEmulator = mkOption {
    type = types.nullOr (types.enum modules);
    default = null;
    example = "alacritty";
    description = ''
      Preferred terminal emulator module provided under `home/common/terminalEmulator`.
      Choose a name to install/configure it or leave null to rely on system defaults.
    '';
  };
}
