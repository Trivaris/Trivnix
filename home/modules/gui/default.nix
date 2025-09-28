{ lib, trivnixLib, ... }:
let
  inherit (lib) mkOption types;
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
  options.userPrefs.gui = mkOption {
    type = types.listOf (types.enum modules);
    default = modules;
    example = [ "vscodium" ];
    description = ''
      GUI application modules to enable from `home/modules/gui`.
      Each entry installs and configures the named desktop program.
    '';
  };
}
