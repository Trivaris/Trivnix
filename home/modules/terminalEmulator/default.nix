{ lib, trivnixLib, ... }:
let
  inherit (lib) mkOption types;
  modules = trivnixLib.getModules ./.;
in
{
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
