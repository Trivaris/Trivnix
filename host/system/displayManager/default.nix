{ lib, trivnixLib, ... }:
let
  modules = trivnixLib.getModules ./.;
in
{
  options.hostPrefs.displayManager = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum modules);
    default = null;
    example = "sddm";
    description = ''
      Display manager module to use from `host/common/displayManager`.
      Choose one to manage graphical logins or keep null for a console setup.
    '';
  };
}
