{ lib, trivnixLib, ... }:
let
  modules = trivnixLib.getModules ./.;
in
{
  options.userPrefs.terminalEmulator = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum modules);
    default = null;
    example = "alacritty";
    description = ''
      Preferred terminal emulator module provided under `home/common/terminalEmulator`.
      Choose a name to install/configure it or leave null to rely on system defaults.
    '';
  };
}
