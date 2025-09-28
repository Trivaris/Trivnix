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
  options.hostPrefs.services = mkOption {
    type = types.listOf (types.enum modules);
    default = [ ];
    example = [ "bluetooth" ];
    description = ''
      Optional host service modules to activate from `host/common/services`.
      Select entries to merge their NixOS service definitions into the system.
    '';
  };
}
