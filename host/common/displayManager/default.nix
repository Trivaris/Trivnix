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
  options.hostPrefs.displayManager = mkOption {
    type = types.nullOr (types.enum modules);
    default = null;
    example = "sddm";
    description = "Your Display Manager";
  };
}
