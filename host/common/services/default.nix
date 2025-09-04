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
  options.hostPrefs.services = mkOption {
    type = types.listOf (types.enum modules);
    default = [ ];
    example = [ "bluetooth" ];
    description = ''
      Services to be enabled.
    '';
  };
}
