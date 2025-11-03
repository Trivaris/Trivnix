{ lib, trivnixLib, ... }:
let
  inherit (lib) mkOption types;
  modules = trivnixLib.getModules ./.;
in
{
  options.hostPrefs.displayManager = mkOption {
    type = types.nullOr (types.enum modules);
    default = null;
    example = "sddm";
    description = ''
      Display manager module to use from `host/common/displayManager`.
      Choose one to manage graphical logins or keep null for a console setup.
    '';
  };
}
