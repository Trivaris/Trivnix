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

  options.hostPrefs.desktopEnvironment = mkOption {
    type = types.nullOr (types.enum modules);
    default = null;
    example = "kde";
    description = ''
      Your Desktop Environment.
    '';
  };
}
