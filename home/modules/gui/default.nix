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
  options.userPrefs.gui = mkOption {
    type = types.listOf (types.enum modules);
    default = [ ];
    example = [ "spotify" ];
    description = "Desktop Apps that you want to enable";
  };
}
